module VagrantPlugins
  module OpsWorks
    module Action
      class CreateRoles
        include VagrantPlugins::OpsWorks::Util::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless enabled?(env)

          setup_role_directory(env[:opsworks])

          env[:machine].env.hook(:opsworks_create_roles, runner: ::Vagrant::Action::Runner.new(env: env))

          require 'pp'
          roles = {}
          env[:opsworks].client.layers.each do |l|
            next if opsworks_config(env).ignore_layers.include?(l['name'])
            roles[l['name']] = {
              'name' => l['name'],
              'description' => l['description'],
              'default_attributes' => {
                'opsworks' => {
                  'layers' => {
                    l['name'] => {
                      'instances' => {}
                    }
                  }
                }
              },
              'run_list' => Hash[Array.new.tap { |a|
                                  l['default_recipes'].each{ |k,v|
                                    a << [k, v.concat(l['custom_recipes'][k])]
                                  }
                                }].select{ |k,v|
                %w(setup configure deploy).any?{ |s|
                  k.to_s == s
                }
              }.values.flatten.select{ |r|
                !opsworks_config(env).ignore_recipes.include?(r)
              }
            }
          end

          roles.each do |role,data|
            data[:chef_type]  = 'role'
            data[:json_class] = 'Chef::Role'
            env[:opsworks].data_directory.join('roles').join("#{role}.json").tap{|p|
              File.open(p, 'w') {|f| f.puts JSON.pretty_generate(JSON.parse(data.to_json)) }
            }
          end

          @app.call(env)
        end

        protected

        def setup_role_directory(opsworks)
          opsworks.data_directory.join('roles').tap{|d|
            FileUtils.mkdir_p(d) unless d.file?
          }
        end
      end
    end
  end
end
