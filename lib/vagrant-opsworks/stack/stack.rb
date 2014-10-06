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

        def get_proc
          return Proc.new { |config|
            select_vmbox(config, @os)
          }
        end

      end
    end
  end
end
