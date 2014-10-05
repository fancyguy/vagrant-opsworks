module VagrantPlugins
  module OpsWorks
    module Errors
      class OpsWorksError < Vagrant::Errors::VagrantError
        error_namespace('vagrant_opsworks.errors')
      end

      class ConnectError < OpsWorksError
        error_key(:connect)
      end
    end
  end
end
