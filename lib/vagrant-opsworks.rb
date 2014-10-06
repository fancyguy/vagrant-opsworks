begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant OpsWorks plugin must be run within Vagrant.'
end

I18n.load_path << File.expand_path('../../locales/en.yml', __FILE__)

require 'vagrant-opsworks/version'
require 'vagrant-opsworks/config'
require 'vagrant-opsworks/errors'
require 'vagrant-opsworks/plugin'

module VagrantPlugins
  module OpsWorks
    class << self
      def source_root
        @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
      end
    end
  end
end
