module VagrantPlugins
  module OpsWorks
    module Action
      class SetupEnvironment

        def initialize(app, env)
          @app = app
        end

        def call(env)
          config, _ = env[:env].config_loader.load([:home, :root])
          env[:opsworks].config = config.opsworks
          env[:opsworks].cache_directory = setup_cache_directory(env)

          @app.call(env)
        end

        protected

        def setup_cache_directory(env)
          cache_dir = env[:env].local_data_path.join('opsworks')
          cache_dir = cache_dir.join(env[:opsworks].stack_id) if env[:opsworks].stack_id
          FileUtils.mkdir_p(cache_dir)
          cache_dir
        end

      end
    end
  end
end
