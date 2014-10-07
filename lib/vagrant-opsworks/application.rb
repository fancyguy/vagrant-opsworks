require 'vagrant/util/hash_with_indifferent_access'

module VagrantPlugins::OpsWorks
  class Application < ::Vagrant::Util::HashWithIndifferentAccess
    class << self

    end

    private

    def set_or_return(key, value)
      if value.nil?
        return self[key]
      else
        self[key] = value
      end
    end

    class Proxy
      def method_missing(m, *args, &block)
        self
      end
    end

  end
end
