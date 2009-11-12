$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
gem 'muck-engine'
require 'muck_test_helper'
require 'authlogic/test_case'
require File.expand_path(File.dirname(__FILE__) + '/factories')

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  include MuckTestMethods
  include Authlogic::TestCase
  # For Selenium
  # setup do |session|
  #   session.host! "localhost:3001"
  # end
end