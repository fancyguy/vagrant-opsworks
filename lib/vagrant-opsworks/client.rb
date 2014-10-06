module VagrantPlugins
  module OpsWorks
    class Client

      attr_reader :stack_id

      def initialize(stack_id, cache=nil)
        @stack_id = stack_id
        @registry = Vagrant::Registry.new
        @cache = cache

        %w(instances layers).each{ |m| @registry.register(m) { build_metadata_proc(m).call } }
      end

      def instances
        @registry['instances']
      end

      def layers
        @registry['layers']
      end

      protected

      def aws_client
        require 'aws-sdk'
        @client ||= AWS::OpsWorks::Client.new
      end

      def build_metadata_proc(type)
        method = "describe_#{type}"
        metadata_proc = Proc.new {
          unless opsworks_reachable?
            raise VagrantPlugins::OpsWorks::Errors::ConnectError
          end

          aws_client.send(method, stack_id: @stack_id)[type.to_sym]
        }

        if @cache.is_a?(Pathname)
          unless File.directory?(@cache)
            FileUtils.mkdir_p(@cache)
          end

          api_proc = metadata_proc

          metadata_proc = Proc.new {
            cache_file = @cache.join(type)

            if cache_file.file?
              Marshal.load(File.read(cache_file))
            else
              data = api_proc.call
              File.open(cache_file, 'w') {|f| f.puts Marshal.dump(data)}
              data
            end
          }
        end

        metadata_proc
      end

      def opsworks_reachable?
        require 'open-uri'
        begin
          true if open('https://opsworks.us-east-1.amazonaws.com', { read_timeout: 2 })
        rescue
          false
        end
      end
    end
  end
end
