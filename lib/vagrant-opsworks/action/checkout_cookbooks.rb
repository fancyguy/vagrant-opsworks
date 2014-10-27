module VagrantPlugins
  module OpsWorks
    module Action
      class CheckoutCookbooks
        include VagrantPlugins::OpsWorks::Util::EnvHelpers
        require 'git'

        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless enabled?(env)

          setup_repo_directory(env)

          opsworks_cookbooks = {
            :url => 'git@github.com:aws/opsworks-cookbooks.git',
            :ref => "release-chef-#{env[:opsworks].client.stack.configuration_manager[:version]}"
          }

          env[:opsworks].ui.info(I18n.t('vagrant_opsworks.action.cookbooks.checkout', {
                                          :repo_name => 'OpsWorks cookbooks',
                                          :repo_url  => opsworks_cookbooks[:url],
                                          :ref => opsworks_cookbooks[:ref]
                                        }))
          prepare_cookbooks(:opsworks, opsworks_cookbooks)

          if env[:opsworks].client.stack.custom_cookbooks?
            custom_cookbooks = {
              :type => 'git',
              :url => env[:opsworks].client.stack.custom_cookbooks_source[:url],
              :ref => env[:opsworks].client.stack.custom_cookbooks_source[:revision]
            }

            custom_cookbooks.merge!(opsworks_config(env).custom_cookbooks_source) if opsworks_config(env).custom_cookbooks_source

            if env[:opsworks].client.stack.custom_cookbooks_source[:type] == 'git'
              env[:opsworks].ui.info(I18n.t('vagrant_opsworks.action.cookbooks.checkout', {
                                              :repo_name => 'custom cookbooks',
                                              :repo_url => custom_cookbooks[:url],
                                              :ref => custom_cookbooks[:ref]
                                            }))
              prepare_cookbooks(:custom, custom_cookbooks)
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
          g.pull(g.remotes.first, g.current_branch)
        end

      end
    end
  end
end
