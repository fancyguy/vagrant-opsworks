module VagrantPlugins
  module OpsWorks
    module Action
      class CreateRoles
        def initialize(app, env)
          @app = app
        end

        def call(env)
          return @app.call(env) unless env[:opsworks].enabled?

          setup_role_directory(env[:opsworks])

          env[:machine].env.hook(:opsworks_create_roles, runner: ::Vagrant::Action::Runner.new(env: env))

          require 'pp'
          roles = {}
          env[:opsworks].layers.each do |l|
            roles[l[:shortname]] = {
              :name => l[:shortname],
              :description => l[:name],
              :default_attributes => {
                :opsworks => {
                  :layers => {
                    l[:shortname] => {}
                  }
                }
              },
              :run_list => Hash[Array.new.tap { |a|
                                  l[:default_recipes].each{ |k,v|
                                    a << [k, v.concat(l[:custom_recipes][k])]
                                  }
                                }].select{ |k,v|
                %w(setup configure deploy).any?{ |s|
                  k.to_s == s
                }
              }.values.flatten.select{ |r|
                !env[:opsworks].ignore_recipes.include?(r)
              }
            } unless env[:opsworks].ignore_layers.include?(l[:shortname])
          end

          roles.each do |role,data|
            data[:chef_type]  = 'role'
            data[:json_class] = 'Chef::Role'
            env[:opsworks].data_directory.join('roles').join("#{role}.json").tap{|p|
              File.open(p, 'w') {|f| f.puts JSON.pretty_generate(JSON.parse(data.to_json)) }
            }
          end

          @app.call(env)
        end

        protected

        def setup_role_directory(opsworks)
          opsworks.data_directory.join('roles').tap{|d|
            FileUtils.mkdir_p(d) unless d.file?
          }
        end
      end
    end
  end
end
