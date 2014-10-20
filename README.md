# Amazon OpsWorks Configuration Provider for Vagrant

<span class="badges">
[![Gem Version](https://badge.fury.io/rb/vagrant-opsworks.svg)][gem]
[![Build Status](https://travis-ci.org/fancyguy/vagrant-opsworks.png?branch=master)][travis]
</span>

[gem]: https://rubygems.org/gems/vagrant-opsworks
[travis]: https://travis-ci.org/fancyguy/vagrant-opsworks

A [Vagrant](http://www.vagrantup.com/) plugin that configures a multi vm environment based on a defined stack in [AWS OpsWorks](http://aws.amazon.com/opsworks/). This is helpful in rapidly spinning up a copy of a production environment without needing to maintain the configuration in multiple locations.

The plugin has only been built for and tested with a very specific configuration:

| Setting                |            Value |
|:---------------------- | ----------------:|
| OS                     | Ubuntu 12.04 LTS |
| Chef                   |            11.10 |
| Custom Cookbook Source |              Git |
| Berkshelf              |            3.1.1 |

## Quick start

Install the plugin:

```sh
vagrant plugin install vagrant-opsworks
```

To enable Vagrant OpsWorks functionality you need to provide at the very least a stack id. You can find this in the AWS console when looking at the overview of your stack. Below `53ad4076-3f76-466e-8ca2-29ea1092cada` will be our example stack id.

```ruby
Vagrant.configure('2') do |config|
  config.opsworks.stack_id = '53ad4076-3f76-466e-8ca2-29ea1092cada'
end
```

## Compatibility

This plugin has not been tested with versions of Vagrant older than 1.6.5 ([downloads](http://www.vagrantup.com/downloads)).
