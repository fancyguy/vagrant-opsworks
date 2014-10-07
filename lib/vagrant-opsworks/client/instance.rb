module VagrantPlugins::OpsWorks
  class Client
    class Instance < VagrantPlugins::OpsWorks::Util::DummyConfiguration

      def hostname(value=nil)
        set_or_return(:hostname, value)
      end

      def layer_ids(value=nil)
        set_or_return(:layer_ids, value)
      end

      def os(value=nil)
        set_or_return(:os, value)
      end

      def architecture(value=nil)
        set_or_return(:architecture, value)
      end

    end
  end
end
