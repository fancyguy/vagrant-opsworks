module VagrantPlugins
  module OpsWorks
    module Action
      class InjectBoxes
        include VagrantPlugins::OpsWorks::Util::EnvHelpers

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless enabled?(env)

          require_relative '../loader'
          require_relative '../util/configuration_builder'

          sources = [find_vagrantfile(env[:env])]

          builder = VagrantPlugins::OpsWorks::Util::ConfigurationBuilder.new(env).tap{ |b|
            b.use VagrantPlugins::OpsWorks::Loader::Stack
            b.use VagrantPlugins::OpsWorks::Loader::Instances
          }

          sources << ['2', builder]

          env[:env].config_loader.set(:root, sources)

          @app.call(env)
        end

        protected

        def find_vagrantfile(environment)
          [* environment.vagrantfile_name || ['Vagrantfile', 'vagrantfile'] ].map{|f|
            environment.root_path.join(f) if environment.root_path.join(f).file?
          }.compact.first
        end

      end
    end
  end
end
