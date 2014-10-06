module VagrantPlugins
  module OpsWorks
    module Stack
      require_relative 'stack/stack'
      require_relative 'stack/instance'

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
