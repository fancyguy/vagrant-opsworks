module VagrantPlugins
  module OpsWorks
    module Action
      class ConfigureChef
        require_relative '../env_helpers'
        include VagrantPlugins::OpsWorks::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless env[:opsworks].enabled?

          if chef_solo?(env)
            provisioners(:chef_solo, env).each do |provisioner|
              provisioner.config.cookbooks_path << [:host, env[:opsworks].data_directory.join('cookbooks/merged').to_s]
              provisioner.config.roles_path << [:host, env[:opsworks].data_directory.join('roles').to_s]
            end
          end

          @app.call(env)
        end

      end
    end
  end
end
