module VagrantPlugins
  module OpsWorks
    module Action
      class SetupEnvironment

        def initialize(app, env)
          @app = app
        end

        def call(env)
          if env.has_key?(:env)
            config, _ = env[:env].config_loader.load([:home, :root])
            environment = env[:env]
          elsif env.has_key?(:machine)
            config = env[:machine].config
            environment = env[:machine].env
          end

          env[:opsworks].config = config.opsworks
          env[:opsworks].data_directory = setup_data_directory(environment, env[:opsworks])

          @app.call(env)
        end

        protected

        def setup_data_directory(environment, opsworks)
          environment.local_data_path.join("opsworks/#{opsworks.stack_id}").tap{|d|
            FileUtils.mkdir_p(d.join('cache')) unless d.join('cache').file?
          }
        end

      end
    end
  end
end
