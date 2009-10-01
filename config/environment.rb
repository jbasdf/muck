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
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem "binarylogic-authlogic", :lib => 'authlogic', :source  => 'http://gems.github.com', :version => ">=2.1.1"
  config.gem "binarylogic-searchlogic", :lib => 'searchlogic', :source  => 'http://gems.github.com', :version => '>= 2.3.1'
  config.gem "bcrypt-ruby", :lib => "bcrypt", :version => ">=2.1.1"
  config.gem 'mbleigh-acts-as-taggable-on', :lib => "acts-as-taggable-on", :source => "http://gems.github.com"
  config.gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => "http://gems.github.com"
  config.gem "collectiveidea-awesome_nested_set", :lib => 'awesome_nested_set', :source => "http://gems.github.com"
  config.gem "openrain-action_mailer_tls", :lib => 'smtp_tls', :source => "http://gems.github.com" # This is only require for installations that have ruby 1.8.6.  If you are running Ruby 1.8.7 you may comment this out and remove require "smtp_tls" from smtp_gmail.rb
  config.gem "friendly_id", :version => '>=2.1.3'
  config.gem "rgrove-sanitize", :lib => 'sanitize'
  config.gem "newrelic_rpm"
  config.gem "muck-feedbag", :lib => "feedbag", :source => "http://gems.github.com"
  config.gem "pauldix-feedzirra", :lib => 'feedzirra', :source => "http://gems.github.com"
  config.gem 'babelphish', :version => '>=0.2.6'
  config.gem 'disguise', :version => '>=0.3.8'
  config.gem 'uploader', :version => '>=0.2.1'
  config.gem 'cms-lite', :lib => 'cms_lite', :version => '>=0.5.4'
  config.gem 'muck-engine', :lib => 'muck_engine', :version => '>=0.2.1'
  config.gem "muck-solr", :lib => 'acts_as_solr', :version => '>=0.4.3'
  config.gem "muck-raker", :lib => 'muck_raker', :version => '>=0.1.36'
  config.gem 'muck-users', :lib => 'muck_users', :version => '>=0.2.12'
  config.gem 'muck-activities', :lib => 'muck_activities', :version => '>=0.1.21'
  config.gem 'muck-comments', :lib => 'muck_comments', :version => '>=0.1.11'
  config.gem 'muck-profiles', :lib => 'muck_profiles', :version => '>=0.1.11'
  config.gem 'muck-friends', :lib => 'muck_friends', :version => '>=0.1.11'
  config.gem 'muck-shares', :lib => 'muck_shares', :version => '>=0.1.5'
  config.gem 'muck-contents', :lib => 'muck_contents', :version => '>=0.1.5'
  config.gem 'muck-blogs', :lib => 'muck_blogs', :version => '>=0.1.5'

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
