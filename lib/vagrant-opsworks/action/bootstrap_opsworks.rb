module VagrantPlugins
  module OpsWorks
    module Action
      class BootstrapOpsWorks
        require_relative '../env_helpers'
        include VagrantPlugins::OpsWorks::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless env[:opsworks].enabled?

          @app.call(env)
        end

      end
    end
  end
end
