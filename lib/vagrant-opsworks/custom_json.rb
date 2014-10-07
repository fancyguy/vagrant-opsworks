module VagrantPlugins::OpsWorks
  require 'vagrant/util/hash_with_indifferent_access'
  class CustomJson < ::Vagrant::Util::HashWithIndifferentAccess

    def deep_merge(other_json, &block)
      dup.deep_merge!(other_json, &block)
    end

    def deep_merge!(other_json, &block)
      other_json.each_pair do |k,theirs|
        our_value = self[k]
        if ours.is_a?(CustomJson) && theirs.is_a?(CustomJson)
          self[k] = ours.deep_merge!(theirs, &block)
        else
          self[k] = block && ours ? block.call(k, ours, theirs) : v
        end
      end
      self
    end

  end
end
