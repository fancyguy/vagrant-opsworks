# -*- mode: ruby; encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'vagrant-opsworks/version'

Gem::Specification.new do |s|
  s.name          = 'vagrant-opsworks'
  s.version       = VagrantPlugins::OpsWorks::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Steve Buzonas']
  s.email         = ['steve@fancyguy.com']
  s.description   = %q{A Vagrant plugin to provision a stack configured in Amazon OpsWorks}
  s.summary       = s.description
  s.homepage      = 'http://github.com/fancyguy/vagrant-opsworks.git'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9.1'

  s.post_install_message = "In order to use the Vagrant-OpsWorks plugin, you must have configured AWS credentials.\n" +
                           "Instructions on providing these can be found at http://docs.aws.amazon.com/AWSSdkDocsRuby/latest//DeveloperGuide/ruby-dg-setup.html#set-up-creds"

  s.add_dependency 'aws-sdk'
  s.add_dependency 'git'

  s.add_development_dependency 'spork', '~> 0.9'
  s.add_development_dependency 'rspec', '~> 2.13'
  s.add_development_dependency 'thor', '~> 0.18'
end
