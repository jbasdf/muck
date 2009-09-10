RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

# Load a global constant so the initializers can use them
require 'ostruct'
require 'yaml'
::GlobalConfig = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/global_config.yml")[RAILS_ENV])

class TestGemLocator < Rails::Plugin::Locator
  def plugins
    Rails::Plugin.new(File.join(File.dirname(__FILE__), *%w(.. .. ..)))
  end 
end

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem "binarylogic-authlogic", :lib => 'authlogic', :source  => 'http://gems.github.com', :version => ">=2.1.1"
  config.gem "binarylogic-searchlogic", :lib => 'searchlogic', :source  => 'http://gems.github.com', :version => '~> 2.1.1'
  config.gem "bcrypt-ruby", :lib => "bcrypt", :version => ">=2.0.5"
  config.gem 'mbleigh-acts-as-taggable-on', :lib => "acts-as-taggable-on", :source => "http://gems.github.com"
  config.gem "collectiveidea-awesome_nested_set", :lib => 'awesome_nested_set', :source => "http://gems.github.com"
  config.gem "friendly_id", :version => '>=2.1.3'
  config.gem "babelphish"
  config.gem 'muck-engine', :lib => 'muck_engine'
  config.gem 'muck-users', :lib => 'muck_users'
  config.gem 'muck-activities', :lib => 'muck_activities'
  config.gem 'muck-comments', :lib => 'muck_comments'
  config.plugin_locators << TestGemLocator
end