module VagrantPlugins
  module OpsWorks
    module Stack
      class Instance
        include VagrantPlugins::OpsWorks::Stack

        # @return [String]
        #   hostname of the instance
        attr_reader :hostname

        # @return [String]
        #   operating system of the instance
        attr_reader :os

        def initialize(opsworks, config)
          @opsworks = opsworks
          @hostname = config[:hostname]
          @os = config[:os]
          @layers = config[:layer_ids]
        end

        def get_proc
          return Proc.new { |config|
            config.vm.define @hostname do |node|
              node.vm.hostname = "#{@hostname}#{@opsworks.hostname_suffix}"
              select_vmbox(node, @os)
            end
          }
        end

      end
    end
  end
end
