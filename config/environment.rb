# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'ostruct'
require 'yaml'
::GlobalConfig = OpenStruct.new(YAML.load_file("#{RAILS_ROOT}/config/global_config.yml")[RAILS_ENV])

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'will_paginate'
  config.gem 'jrails'
  config.gem "authlogic", :version => ">=2.1.2"
  config.gem "searchlogic", :version => '>= 2.3.5'
  config.gem "bcrypt-ruby", :lib => "bcrypt", :version => ">=2.1.1"
  config.gem 'acts-as-taggable-on'
  config.gem 'paperclip'
  config.gem "awesome_nested_set", :lib => 'awesome_nested_set'
  config.gem "friendly_id", :version => '>=2.2.0'
  config.gem "sanitize"
  config.gem "recaptcha", :lib => "recaptcha/rails"
  config.gem "newrelic_rpm"
  config.gem "feedzirra"
  config.gem 'tiny_mce'
  config.gem 'geokit'
  config.gem 'httparty'
  config.gem "oauth"
  config.gem "oauth-plugin"
  config.gem "disguise"
  config.gem 'babelphish', :version => '>=0.2.6'
  config.gem 'uploader', :version => '>=0.2.7'
  config.gem 'muck-engine', :lib => 'muck_engine', :version => '>=0.2.21'
  config.gem "muck-solr", :lib => 'acts_as_solr', :version => '>=0.4.5'
  config.gem "muck-feedbag", :lib => 'feedbag', :version => '>=0.6.0'
  config.gem "muck-raker", :lib => 'muck_raker', :version => '>=0.3.6'
  config.gem "muck-services", :lib => 'muck_services', :version => '>=0.1.23'
  config.gem 'muck-users', :lib => 'muck_users', :version => '>=0.2.18'
  config.gem 'muck-activities', :lib => 'muck_activities', :version => '>=0.1.25'
  config.gem 'muck-comments', :lib => 'muck_comments', :version => '>=0.1.17'
  config.gem 'muck-profiles', :lib => 'muck_profiles', :version => '>=0.1.18'
  config.gem 'muck-friends', :lib => 'muck_friends', :version => '>=0.1.17'
  config.gem 'muck-shares', :lib => 'muck_shares', :version => '>=0.1.8'
  config.gem 'muck-contents', :lib => 'muck_contents', :version => '>=0.2.11'
  config.gem 'muck-blogs', :lib => 'muck_blogs', :version => '>=0.1.8'
  config.gem 'muck-invites', :lib => 'muck_invites', :version => '>=0.1.5'
  config.gem 'muck-oauth', :lib => 'muck_oauth', :version => '>=0.1.1'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  config.i18n.default_locale = :en

end
