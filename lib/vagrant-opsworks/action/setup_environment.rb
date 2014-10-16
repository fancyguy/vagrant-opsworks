module VagrantPlugins
  module OpsWorks
    module Action
      class SetupEnvironment
        require_relative '../util/env_helpers'
        include VagrantPlugins::OpsWorks::Util::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless enabled?(env)

          env[:opsworks].data_directory = setup_data_directory

          require_relative '../client'
          env[:opsworks].client = VagrantPlugins::OpsWorks::Client.new(stack_id(env))

          @app.call(env)
        end

        protected

        def setup_data_directory
          Vagrant.user_data_path.join('opsworks').tap{|d|
            FileUtils.mkdir_p(d.join('cache')) unless d.join('cache').file?
          }
        end

      end
    end
  end
end
