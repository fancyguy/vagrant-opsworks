module VagrantPlugins::OpsWorks
  class Client
    class App < VagrantPlugins::OpsWorks::Util::DummyConfiguration

      def shortname(value=nil)
        set_or_return(:name, value)
      end

      def name(value=nil)
        set_or_return(:description, value)
      end

      def data_sources(value=nil)
        set_or_return(:data_sources, value)
      end

      def type(value=nil)
        set_or_return(:type, value)
      end

      def app_source(value=nil)
        set_or_return(:app_source, value)
      end

      def domains(value=nil)
        set_or_return(:domains, value)
      end

      def enable_ssl(value=nil)
        set_or_return(:enable_ssl, value)
      end

      def ssl_configurations(value=nil)
        set_or_return(:ssl_configurations, value)
      end

      def attributes(value=nil)
        set_or_return(:attributes, value)
      end

      def environment(value=nil)
        unless value.nil?
          value = value.select{|v| !v[:secure]}
        end
        set_or_return(:environment, value)
      end

    end
  end
end
