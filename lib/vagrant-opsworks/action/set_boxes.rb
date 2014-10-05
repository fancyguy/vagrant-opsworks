module VagrantPlugins
  module OpsWorks
    module Action
      class SetBoxes
        require_relative '../env_helpers'
        require_relative '../stack'

        include VagrantPlugins::OpsWorks::EnvHelpers
        include VagrantPlugins::OpsWorks::Stack

        def initialize(app, env)
          @app = app
        end

        def call(env)
          unless opsworks_enabled?(env)
            return @app.call(env)
          end

          sources = []
          instances(stack_id(env)).each{|i,d|
            sources << ['2', d.get_proc]
          }

          vagrantfile_name = env[:env].vagrantfile_name || ['Vagrantfile', 'vagrantfile']
          vagrantfile_name = [*vagrantfile_name]

          sources.unshift(vagrantfile_name.map{|f| 
            current_path = env[:env].root_path.join(f)
            current_path if current_path.file?
          }.compact.first)

          env[:env].config_loader.set(:root, sources)

          return @app.call(env)
        end

      end
    end
  end
end
