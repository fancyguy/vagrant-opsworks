module VagrantPlugins
  module OpsWorks
    class Config < ::Vagrant.plugin('2', :config)
      # @return [Boolean]
      #   disable use of OpsWorks in Vagrant
      attr_accessor :enabled

      # @return [Boolean]
      #   disable use of OpsWorks Cache
      attr_accessor :cache

      # @return [String]
      #   OpsWorks stack id
      attr_accessor :stack_id

      def initialize
        super

        @cache            = false
        @enabled          = UNSET_VALUE
        @stack_id         = UNSET_VALUE
        @ignore_instances = Array.new
        @ignore_recipes   = Array.new
        @ignore_layers    = Array.new
      end

      def finalize!
        @enabled = @stack_id == UNSET_VALUE ? false : true if @enabled == UNSET_VALUE
      end

      def validate(machine)
        errors = Array.new
        unless [TrueClass, FalseClass].include?(enabled.class)
          errors << I18n.t('vagrant_opsworks.config.not_a_bool', {
            :config_key => 'opsworks.enabled'
          })
        end

        unless [TrueClass, FalseClass].include?(cache.class)
          errors << I18n.t('vagrant_opsworks.config.not_a_bool', {
            :config_key => 'opsworks.cache'
          })
        end

        {'opsworks configuration' => errors}
      end
    end
  end
end
