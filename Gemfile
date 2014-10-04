# -*- mode: ruby; encoding: utf-8 -*-
source 'https://rubygens.org'

gemspec

group :development do
  gem 'vagrant', github: 'mitchellh/vagrant', tag: 'v1.6.3'
end

group :plugins do
  gem 'vagrant-opsworks', path: '.'
end

group :guard do
  gem 'coolline'
  gem 'fuubar'
  gem 'guard', '>= 1.5.0'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-yard'
  gem 'redcarpet'
  gem 'yard'

  require 'rbconfig'

  if RbConfig::Config['target_os'] =~ /darwin/i
    gem 'growl', require: false
    gem 'rbfsevent', require: false

    if `uname`.strip == 'Darwin' && `sw_vers -productVersion`.strip >= '10.8'
      gem 'terminal-notifier-guard', '~> 1.5.3', require: false
    end rescue Errno::ENOENT

  elsif RbConfig::['target_os'] =~ /linux/i
    gem 'libnotify', '~> 0.8.0', require:false
    gem 'rb-inotify', require: false

  elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
    gem 'rb-notifu', '>= 0.0.4', require: false
    gem 'wdm', require: false
    gem 'win32console', require: false
  end
end
