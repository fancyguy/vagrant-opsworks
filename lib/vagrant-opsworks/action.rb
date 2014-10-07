module VagrantPlugins
  module OpsWorks
    module Action
      require_relative 'util/env_helpers'
      require_relative 'env'
      require_relative 'action/checkout_cookbooks'
      require_relative 'action/configure_berks'
      require_relative 'action/configure_chef'
      require_relative 'action/create_roles'
      require_relative 'action/inject_boxes'
      require_relative 'action/merge_cookbooks'
      require_relative 'action/setup_environment'
      class << self
        def prepare_environment
          @prepare_environment ||= environment_builder.tap do |b|
            b.use VagrantPlugins::OpsWorks::Action::InjectBoxes
          end
        end

        def setup
          @setup ||= environment_builder.tap do |b|
            b.use VagrantPlugins::OpsWorks::Action::CreateRoles
          end
        end

        def configure_berks
          @configure_berks ||= environment_builder.tap do |b|
            b.use VagrantPlugins::OpsWorks::Action::ConfigureBerks
          end
        end

        def configure_chef
          @configure_chef ||= environment_builder.tap do |b|
            b.use VagrantPlugins::OpsWorks::Action::ConfigureChef
          end
        end

        protected

        def environment_builder
          ::Vagrant::Action::Builder.new.tap do |b|
            b.use ::Vagrant::Action::Builtin::EnvSet, opsworks: VagrantPlugins::OpsWorks::Env.new
            b.use VagrantPlugins::OpsWorks::Action::SetupEnvironment
          end
        end

      end

    end
  end
end
