module VagrantPlugins
  module OpsWorks
    class Client

      attr_reader :stack_id

      def initialize(stack_id, cache=nil)
        @stack_id = stack_id
        @registry = Vagrant::Registry.new
        @cache = cache

        %w(instances layers).each{ |m| @registry.register(m) { build_metadata_proc(m).call } }
        @registry.register('stacks') {
          api_proc = Proc.new {
            unless opsworks_reachable?
              raise VagrantPlugins::OpsWorks::Errors::ConnectError
            end

            aws_client.describe_stacks(stack_ids: [@stack_id])[:stacks]
          }
          build_api_proc('stacks', api_proc).call
        }
      end

      def instances
        @registry['instances']
      end

      def layers
        @registry['layers']
      end

      def stack
        @registry['stacks'].first
      end

      protected

      def aws_client
        require 'aws-sdk'
        @client ||= AWS::OpsWorks::Client.new
      end

      def build_metadata_proc(type)
        method = "describe_#{type}"
        api_proc = Proc.new {
          unless opsworks_reachable?
            raise VagrantPlugins::OpsWorks::Errors::ConnectError
          end

          aws_client.send(method, stack_id: @stack_id)[type.to_sym]
        }
        build_api_proc(type, api_proc)
      end

      def build_api_proc(type, metadata_proc)
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
