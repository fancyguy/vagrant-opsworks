module VagrantPlugins::OpsWorks::Loader
  class Instances

    def initialize(app, opsworks)
      @app      = app
      @opsworks = opsworks
    end

    def call(env)
      return @app.pass(env) unless @opsworks.enabled

      instances = env[:client].instances.sort_by{|i| i['hostname']}

      apps = {}
      env[:client].apps.each do |a|
        next if @opsworks.ignore_apps.include?(a['name'])
        app = {
          'application'           => a['name'],
          'application_type'      => a['type'],
          'environment'           => a['environment'].nil? ? {} : Hash[a['environment'].select{|e| !e[:secure] }.map{|e| [e[:key], e[:value]]}],
          'auto_bundle_on_deploy' => a['attributes']['AutoBundleOnDeploy'],
          'deploying_user'        => Etc.getlogin,
          'document_root'         => a['attributes']['DocumentRoot'],
          'domains'               => a['domains'],
          'database'              => {},
          'memcached'             => { 'host' => nil, 'port' => 11211 },
          'scm'                   => {}
        }
        if a['app_source'][:type] == 'git'
          app['scm'] = {
            'scm_type'   => 'git',
            'repository' => a[:app_source][:url],
            'ssh_key'    => nil,
            'user'       => nil,
            'password'   => nil
          }
        end
        apps[a['name']] = app
      end

      instances.each do |i|
        next if @opsworks.ignore_instances.include?(i['hostname'])
        env[:config].vm.define i['hostname'] do |node|
          VagrantPlugins::OpsWorks::Loader.select_vmbox(env[:config], i['os'])

          node.vm.provision :chef_solo do |chef|
            pkgs = []
            i['layer_ids'].each do |l|
              next if @opsworks.ignore_layers.include?(l['name'])
              layer = env[:client].layers.select{|x| x['layer_id'] == l}.first
              chef.add_role layer['name']
              pkgs << layer['packages']
            end

            custom_json = env[:client].stack.custom_json.dup
            custom_json.merge!({
              'opsworks' => {
                'activity'      => 'setup',
                'agent_version' => @opsworks.agent_version,
                'sent_at'       => Time.new.to_i,
                'deployment'    => SecureRandom.uuid
              },
              'dependencies' => {
                'debs' => pkgs.flatten.map{|x| [x, nil]}.to_h
              },
              'deploy' => apps
            })

            chef.json = custom_json
          end
        end
      end

      @app.pass(env)
    end

  end
end
