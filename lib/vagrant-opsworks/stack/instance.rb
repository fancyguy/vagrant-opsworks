module VagrantPlugins
  module OpsWorks
    module Stack
      class Instance
        # @return [String]
        #   hostname of the instance
        attr_reader :hostname

        # @return [String]
        #   operating system of the instance
        attr_reader :os

        def initialize(config)
          @hostname = config[:hostname]
          @os = config[:os]
          @layers = config[:layer_ids]
        end

        def get_proc
          return Proc.new { |config|
            config.vm.define @hostname do |node|
              select_vmbox(node, @os)
            end
          }
        end

        protected

        def select_vmbox(config, os)
          suffix = /x86_64/ =~ RUBY_PLATFORM ? '' : '-i386'
          case os
          when /^Ubuntu/
            version = os.split(' ')[1]
            config.vm.box = "chef/ubuntu-#{version}#{suffix}"
          else
            config.vm.box = "chef/centos-6.5#{suffix}"
          end
        end
      end
    end
  end
end
