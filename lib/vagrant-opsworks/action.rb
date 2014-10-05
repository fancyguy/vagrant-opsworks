module VagrantPlugins
  module OpsWorks
    module Action
      require_relative 'action/set_boxes'
      class << self
        def set_boxes
          @set_boxes ||= ::Vagrant::Action::Builder.new.tap do |b|
            b.use VagrantPlugins::OpsWorks::Action::SetBoxes
          end
        end
      end
    end
  end
end
