module VagrantPlugins
  module OpsWorks
    module Action
      class SetupEnvironment

        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:opsworks].data_directory = setup_data_directory

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
