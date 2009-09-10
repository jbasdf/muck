# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

HOST = "localhost"

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql

config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
config.gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com'
config.gem 'treetop', :version => '>=1.2.4'
config.gem 'term-ansicolor', :version => '>=1.0.3', :lib => 'term/ansicolor'
config.gem 'polyglot', :version => '>=0.2.4'
config.gem "rcov", :version => '>=0.8.1.2.0'

# only required if you want to use selenium for testing
config.gem 'selenium-client', :lib => 'selenium/client'
config.gem 'bmabey-database_cleaner', :lib => 'database_cleaner', :source => 'http://gems.github.com'

require 'factory_girl'
begin require 'redgreen'; rescue LoadError; end