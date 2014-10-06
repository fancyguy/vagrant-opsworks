module VagrantPlugins
  module OpsWorks
    module Stack
      class Stack
        include VagrantPlugins::OpsWorks::Stack

        # @return [String]
        attr_reader :name

        def initialize(opsworks, config)
          @opsworks = opsworks
          @name = config[:name]
          @custom_json = config[:custom_json]
          @os = config[:default_os]
          @custom_cookbooks = config[:use_custom_cookbooks]
          @configuration_manager = config[:configuration_manager]
          @chef_configuration = config[:chef_configuration]
          @cookbooks_source = config[:custom_cookbooks_source]
        end

        def berks_enabled?
          @chef_configuration[:manage_berkshelf]
        end

        def custom_cookbooks?
          @custom_cookbooks
        end

        def custom_cookbooks
          case @cookbooks_source[:type]
          when 'git'
            {
              :type => 'git',
              :url => @cookbooks_source[:url],
              :ref => @cookbooks_source[:revision]
            }
          end
        end

        def opsworks_cookbooks
          {
            :url => 'git@github.com:aws/opsworks-cookbooks.git',
            :ref => "release-chef-#{@configuration_manager[:version]}"
          }
        end

        # @return [Hash]
        def custom_json
          JSON.parse(@custom_json)
        end

        def get_proc
          return Proc.new { |config|
            select_vmbox(config, @os)

            config.vm.provision :shell, inline: File.read(VagrantPlugins::OpsWorks.source_root.join('provisioning/install-agent.sh'))

            config.vm.provision :chef_solo do |chef|
              chef.json = custom_json
            end
          }
        end

      end
    end
  end
end
