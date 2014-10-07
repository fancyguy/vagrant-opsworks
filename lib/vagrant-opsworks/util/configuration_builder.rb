module VagrantPlugins::OpsWorks::Util
  class ConfigurationBuilder

    # @return [Array]
    attr_reader :stack

    def initialize(env)
      @runner = ::Vagrant::Action::Runner.new({:env => env, :action_name => :opsworks_configuration})
      @stack = []
    end

    def use(loader, *args, &block)
      self.stack << [loader, args, block]

      self
    end

    def call(config)
      @stack.each do |loader|
        @runner.run(finalize_loader(loader, config), {:config => config})
      end
    end

    def finalize_loader(loader, config)
      klass, args, block = loader
      args ||= []

      if klass.is_a?(Class)
        klass.new(self, config, *args, &block)
      elsif klass.respond_to?(:call)
        lambda do |e|
          klass.call(e)
          self.call(e)
        end
      end
    end

  end
end
