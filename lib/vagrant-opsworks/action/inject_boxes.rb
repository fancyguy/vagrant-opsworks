module VagrantPlugins
  module OpsWorks
    module Action
      class InjectBoxes

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless env[:opsworks].enabled?

          sources = [find_vagrantfile(env[:env])]
          env[:opsworks].instances.each{|i,d| sources << ['2', d.get_proc]}

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
