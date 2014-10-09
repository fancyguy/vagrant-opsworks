module VagrantPlugins::OpsWorks::Util
  class ConfigurationBuilder

    # @return [Array]
    attr_reader :stack

    def initialize(config)
      @opsworks = config
      @runner = ::Vagrant::Action::Runner.new({:action_name => :opsworks_configuration})
      @stack = []
    end

    def use(loader, *args, &block)
      self.stack << finalize_loader(loader, args, block)

      self
    end

    def call(config)
      @stack.each do |loader|
        @runner.run(@stack.shift, {:config => config})
      end
    end

    def finalize_loader(klass, args, block)
      args ||= []

      if klass.is_a?(Class)
        klass.new(self, @opsworks, *args, &block)
      elsif klass.respond_to?(:call)
        lambda do |e|
          klass.call(e)
          self.call(e)
        end
      end
    end

  end
end
