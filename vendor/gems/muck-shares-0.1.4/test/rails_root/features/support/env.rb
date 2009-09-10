# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require File.expand_path(File.dirname(__FILE__) +  '/../../test/test_helper')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Share out this line if you don't want Cucumber Unicode support

require 'database_cleaner'
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation

Cucumber::Rails.use_transactional_fixtures

# Share out the next line if you want Rails' own error handling
# (e.g. rescue_action_in_public / rescue_responses / rescue_from)
Cucumber::Rails.bypass_rescue

require 'webrat'
require 'cucumber/webrat/table_locator' # Lets you do table.diff!(table_at('#my_table').to_a)

# Share out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
#require 'webrat/rspec-rails'

require 'webrat/core/matchers'

Webrat.configure do |config|
  config.mode = :rails
end

# Webrat.configure do |config|  
#   config.mode = :selenium  
#   config.application_environment = :test  
#   config.application_framework = :rails  
# end

# To enable selenium:
# 1. sudo gem install selenium-client
# 2. unshare Webrat.configure that contains :selenium and then share out the one that contains :rails above
# 3. set:  self.use_transactional_fixtures = false in test_helper.rb
# 4. unshare in test_helper.rb:
      # setup do |session|
      #   session.host! "localhost:3001"
      # end
# 5. Be sure to apply the patch mentioned in the viget article below found here: http://gist.github.com/141590
      
# References:
# http://www.brynary.com/2009/4/6/switching-webrat-to-selenium-mode
# http://www.viget.com/extend/getting-started-with-webrat-selenium-rails-and-firefox-3/