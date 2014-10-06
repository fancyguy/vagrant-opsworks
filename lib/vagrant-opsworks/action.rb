module VagrantPlugins
  module OpsWorks
    module Action
      require_relative 'env'
      require_relative 'action/setup_environment'
      require_relative 'action/inject_boxes'
      class << self
        def prepare_environment
          @prepare_environment ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use ::Vagrant::Action::Builtin::EnvSet, opsworks: VagrantPlugins::OpsWorks::Env.new
            b.use VagrantPlugins::OpsWorks::Action::SetupEnvironment
            b.use VagrantPlugins::OpsWorks::Action::InjectBoxes
          end
        end
      end
    end
  end
end
