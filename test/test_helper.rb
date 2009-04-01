$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.expand_path(File.dirname(__FILE__) + '/test_definitions')
require 'test_help'
require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '/factories')
class ActiveSupport::TestCase
  
  include TestDefinitions
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  self.backtrace_silencers << :rails_vendor
  self.backtrace_filters << :rails_root
  fixtures :all
end
