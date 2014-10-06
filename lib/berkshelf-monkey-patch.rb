require 'berkshelf/vagrant'
require 'berkshelf/vagrant/action'

module Berkshelf
  module Vagrant
    module Action
      require 'vagrant-opsworks/action'
      include VagrantPlugins::OpsWorks::Action

      class << self
        alias_method :old_setup, :setup
      end

      def self.setup
        old_setup.tap do |b|
          b.use ::Vagrant::Action::Builtin::EnvSet, opsworks: VagrantPlugins::OpsWorks::Env.new
          b.use VagrantPlugins::OpsWorks::Action::SetupEnvironment
          b.use VagrantPlugins::OpsWorks::Action::MergeCookbooks
          b.use VagrantPlugins::OpsWorks::Action::ConfigureChef
        end
      end

    end
  end
end
