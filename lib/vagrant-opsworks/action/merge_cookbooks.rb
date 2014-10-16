module VagrantPlugins
  module OpsWorks
    module Action
      class MergeCookbooks
        include VagrantPlugins::OpsWorks::Util::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless enabled?(env)

          cookbook_path = env[:opsworks].data_directory.join('cookbooks').tap{|d| FileUtils.mkdir_p(d.join('merged')) unless d.join('merged').file? }

          FileUtils.cp_r cookbook_path.join('opsworks/.').to_s, cookbook_path.join('merged').to_s, :remove_destination => true
          FileUtils.cp_r env[:berkshelf].shelf + '/.',          cookbook_path.join('merged').to_s, :remove_destination => true if env[:berkshelf].shelf
          FileUtils.cp_r cookbook_path.join('custom/.').to_s,   cookbook_path.join('merged').to_s, :remove_destination => true if env[:opsworks].client.stack.use_custom_cookbooks?
          FileUtils.rm_r cookbook_path.join('merged/.git').to_s

          @app.call(env)
        end

      end
    end
  end
end
