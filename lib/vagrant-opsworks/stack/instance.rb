module VagrantPlugins
  module OpsWorks
    module Stack
      class Instance

        def initialize(stack, config)
          @stack = stack
          @hostname = config[:hostname]
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
            config.vm.box = "opscode_ubuntu-#{version}#{suffix}_chef-provisionerless"
            config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-#{version}#{suffix}_chef-provisionerless.box"
          else
            config.vm.box = "opscode_centos-6.5#{suffix}_chef-provisionerless"
            config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5#{suffix}_chef-provisionerless.box"
          end
        end
      end
    end
  end
end
