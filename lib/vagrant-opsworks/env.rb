module VagrantPlugins
  module OpsWorks
    require_relative 'stack'
    class Env
      # @return [Vagrant::UI::Colored]
      attr_accessor :ui
      # @return [VagrantPlugins::OpsWorks::Config]
      attr_accessor :config
      # @return [Pathname]
      attr_accessor :cache_directory

      def initialize
        @ui               = ::Vagrant::UI::Colored.new
        @ui.opts[:target] = 'OpsWorks'
        @logger = Log4r::Logger.new("vagrantplugins::opsworks::env")
      end

      # @return [Boolean]
      def enabled?
        begin
          config.enabled
        rescue
          false
        end
      end

      # @return [Boolean]
      def cache_enabled?
        begin
          config.cache
        rescue
          false
        end
      end

      # @return [Pathname]
      def cache_directory
        if cache_enabled?
          @cache_directory
        end
      end

      # @return [String]
      def stack_id
        unless config.nil?
          config.stack_id
        end
      end

      # @return [Array]
      def ignore_instances
        unless config.nil?
          config.ignore_instances
        end
      end

      def instances
        if stack_id
          instances = Vagrant::Registry.new
          client.instances.sort_by{|i| i[:hostname]}.each do |i|
            unless ignore_instances.include?(i[:hostname])
              instances.register(i[:hostname]) {
                VagrantPlugins::OpsWorks::Stack::Instance.new(i)
              }
            end
          end
          instances
        end
      end

      protected

      def client
        require_relative 'client'
        @client ||= Client.new(stack_id, cache_directory)
      end
    end
  end
end
