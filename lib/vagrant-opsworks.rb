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

  end
end
