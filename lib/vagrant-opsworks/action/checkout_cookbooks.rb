module VagrantPlugins
  module OpsWorks
    module Action
      class CheckoutCookbooks
        require 'git'

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless env[:opsworks].enabled?

          setup_repo_directory(env)

          env[:opsworks].ui.info(I18n.t('vagrant_opsworks.action.cookbooks.checkout', {
                                          :repo_name => 'OpsWorks cookbooks',
                                          :repo_url => env[:opsworks].stack.opsworks_cookbooks[:url],
                                          :ref => env[:opsworks].stack.opsworks_cookbooks[:ref]
                                        }))
          prepare_cookbooks(:opsworks, env[:opsworks].stack.opsworks_cookbooks)

          if env[:opsworks].stack.custom_cookbooks?
            if env[:opsworks].stack.custom_cookbooks[:type] == 'git'
              env[:opsworks].ui.info(I18n.t('vagrant_opsworks.action.cookbooks.checkout', {
                                              :repo_name => 'custom cookbooks',
                                              :repo_url => env[:opsworks].stack.custom_cookbooks[:url],
                                              :ref => env[:opsworks].stack.custom_cookbooks[:ref]
                                            }))
              prepare_cookbooks(:custom, env[:opsworks].stack.custom_cookbooks)
            end
          end

          @app.call(env)
        end

        protected

        def setup_repo_directory(env)
          @repo_path = env[:opsworks].data_directory.join('cookbooks').tap{|f| FileUtils.mkdir_p(f) unless f.file? }
        end

        def prepare_cookbooks(type, settings)
          repo = @repo_path.join(type.to_s).tap{|d|
            FileUtils.mkdir_p(d) unless d.file?
          }
          if (Dir.entries(repo) - %w{ . .. }).empty?
            g = Git.clone(settings[:url], type.to_s, :path => @repo_path)
          else
            g = Git.open(repo)
          end

          g.checkout(settings[:ref])
        end

      end
    end
  end
end
