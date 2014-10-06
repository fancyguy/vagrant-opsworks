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
          @configuration_manager = config[:configuration_manager]
          @cookbooks_source = config[:cookbooks_source]
        end

        # @return [Hash]
        def custom_json
          JSON.parse(@custom_json)
        end

        def get_proc
          return Proc.new { |config|
            select_vmbox(config, @os)

            config.vm.provision :shell, inline: File.read(VagrantPlugins::OpsWorks.source_root.join('provisioning/install-agent.sh'))

            # config.vm.provision :chef_solo do |chef|
            #   chef.json = custom_json
            # end
          }
        end

      end
    end
  end
end
