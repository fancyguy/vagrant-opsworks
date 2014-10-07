module VagrantPlugins
  module OpsWorks
    module Action
      class ConfigureBerks
        include VagrantPlugins::OpsWorks::Util::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless enabled?(env)

          if env[:opsworks].stack.berks_enabled?
            ENV['BERKSHELF_PATH'] = env[:opsworks].data_directory.join('berkshelf').to_s
            env[:machine].config.berkshelf.enabled = true
            env[:machine].config.berkshelf.berksfile_path = env[:opsworks].data_directory.join('cookbooks/custom/Berksfile').to_s
          end

          @app.call(env)
        end

      end
    end
  end
end
