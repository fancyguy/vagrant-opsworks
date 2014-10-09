require 'rubygems'
require 'bundler/setup'
require 'spork'
require 'simplecov'

Spork.prefork do
  require 'simplecov' unless ENV['DRB']
  require 'rspec'

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true

    config.order = 'random'
  end
end

Spork.each_run do
  require 'simplecov' if ENV['DRB']

  require 'vagrant-opsworks'
end
