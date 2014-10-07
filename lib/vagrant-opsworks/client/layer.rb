module VagrantPlugins::OpsWorks
  class Client
    class Layer < VagrantPlugins::OpsWorks::Util::DummyConfiguration

      def layer_id(value=nil)
        set_or_return(:layer_id, value)
      end

      def type(value=nil)
        set_or_return(:type, value)
      end

      def name(value=nil)
        set_or_return(:description, value)
      end

      def shortname(value=nil)
        set_or_return(:name, value)
      end

      def attributes(value=nil)
        set_or_return(:attributes, value)
      end

      def packages(value=nil)
        set_or_return(:packages, value)
      end

      def default_recipes(value=nil)
        set_or_return(:default_recipes, value)
      end

      def custom_recipes(value=nil)
        set_or_return(:custom_recipes, value)
      end

    end
  end
end
