module VagrantPlugins
  module OpsWorks
    class Config < ::Vagrant.plugin('2', :config)
      # @return [Boolean]
      #   disable use of OpsWorks in Vagrant
      attr_accessor :enabled

      # @return [String]
      #   OpsWorks stack id
      attr_accessor :stack_id

      def initialize
        super

        @enabled  = UNSET_VALUE
        @stack_id = UNSET_VALUE
      end

      def finalize!
        @enabled = @stack_id == UNSET_VALUE ? false : true if @enabled == UNSET_VALUE
      end

      def validate(machine)
        errors = Array.new
        unless [TrueClass, FlaseClass].include?(enabled.class)
          errors << I18n.t('vagrant_opsworks.config.enabled')
        end

        {'opsworks_configuration' => errors}
      end
    end
  end
end
