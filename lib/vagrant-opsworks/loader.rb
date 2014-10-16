module VagrantPlugins
  module OpsWorks
    module Loader
      require_relative 'loader/client'
      require_relative 'loader/stack'
      require_relative 'loader/instances'

      class << self

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
