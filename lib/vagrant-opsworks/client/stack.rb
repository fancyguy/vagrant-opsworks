module VagrantPlugins::OpsWorks
  class Client
    class Stack < VagrantPlugins::OpsWorks::Util::DummyConfiguration

      def name(value=nil)
        set_or_return(:name, value)
      end

      def default_os(value=nil)
        set_or_return(:default_os, value)
      end

      def configuration_manager(value=nil)
        set_or_return(:configuration_manager, value)
      end

      def use_custom_cookbooks?
        self['use_custom_cookbooks']
      end

      def use_custom_cookbooks(value=nil)
        set_or_return(:use_custom_cookbooks, value)
      end

      def custom_cookbooks_source(value=nil)
        set_or_return(:custom_cookbooks_source, value)
      end

      def custom_json(value=nil)
        require_relative '../custom_json'
        unless value.nil?
          value = CustomJson.new(JSON.parse(value)) if value.is_a?(String)
        end
        set_or_return(:custom_json, value)
      end

    end
  end
end
