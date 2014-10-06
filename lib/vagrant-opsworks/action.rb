module VagrantPlugins
  module OpsWorks
    module Action
      require_relative 'env'
      require_relative 'action/bootstrap_opsworks'
      require_relative 'action/create_roles'
      require_relative 'action/inject_boxes'
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
            b.use VagrantPlugins::OpsWorks::Action::BootstrapOpsWorks
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
