module VagrantPlugins::OpsWorks
  require 'vagrant/util/hash_with_indifferent_access'
  class CustomJson < ::Vagrant::Util::HashWithIndifferentAccess

    def initialize(hash={}, &block)
      super(hash, &block)

      self.each_pair do |k,v|
        v = self.class.new(v) if v.is_a?(Hash)
        self[k] = v
      end
    end

    def deep_merge(other_json, &block)
      dup.deep_merge!(other_json, &block)
    end

    def deep_merge!(other_json, &block)
      other_json.each_pair do |k,theirs|
        ours = self[k]
        if ours.is_a?(CustomJson) && theirs.is_a?(Hash)
          self[k] = ours.deep_merge!(theirs, &block)
        else
          self[k] = block && ours ? block.call(k, ours, theirs) : theirs
        end
      end
      self
    end

  end
end
