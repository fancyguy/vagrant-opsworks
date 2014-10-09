# -*- mode: ruby; encoding: utf-8 -*-
SimpleCov.start do
  add_group "Actions", 'vagrant-opsworks/action'
  add_group "Client", 'vagrant-opsworks/client'
  add_group "Loader", 'vagrant-opsworks/loader'
  add_group "Utility", 'vagrant-opsworks/util'
end
