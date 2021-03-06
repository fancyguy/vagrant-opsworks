require 'vagrant-berkshelf/action/base'

module VagrantPlugins
  module Berkshelf
    module Action
      require 'vagrant-opsworks/action'
      include VagrantPlugins::OpsWorks::Action

      class Base
        class << self
          alias_method :old_setup, :setup
        end

        def self.setup
          Vagrant::Action::Builder.new.tap do |b|
            b.use old_setup
            b.use ::Vagrant::Action::Builtin::EnvSet, opsworks: VagrantPlugins::OpsWorks::Env.new
            b.use VagrantPlugins::OpsWorks::Action::SetupEnvironment
            b.use VagrantPlugins::OpsWorks::Action::CheckoutCookbooks
            b.use VagrantPlugins::OpsWorks::Action::MergeCookbooks
            b.use VagrantPlugins::OpsWorks::Action::ConfigureChef
          end
        end
      end

    end
  end
end
