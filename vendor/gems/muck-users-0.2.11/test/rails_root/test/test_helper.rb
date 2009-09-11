$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
gem 'thoughtbot-factory_girl' # from github
require 'factory_girl'
require 'mocha'
require 'authlogic/test_case'
require 'redgreen' rescue LoadError
require File.expand_path(File.dirname(__FILE__) + '/factories')
require File.join(File.dirname(__FILE__), 'shoulda_macros', 'controller')
require File.join(File.dirname(__FILE__), 'shoulda_macros', 'models')

class ActiveSupport::TestCase 
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  include Authlogic::TestCase
  
  def login_as(user)
    success = UserSession.create(user)
    if !success
      errors = user.errors.full_messages.to_sentence
      message = 'User has not been activated' if !user.active?
      raise "could not login as #{user.to_param}.  Please make sure the user is valid. #{message} #{errors}"
    end
    UserSession.find
  end
  
  def assure_logout
    user_session = UserSession.find
    user_session.destroy if user_session
  end
  
  def ensure_flash(val)
    assert_contains flash.values, val, ", Flash: #{flash.inspect}"
  end

  # Add more helper methods to be used for testing xml
  def assert_xml_tag(xml, conditions)
    doc = HTML::Document.new(xml)
    assert doc.find(conditions), 
      "expected tag, but no tag found matching #{conditions.inspect} in:\n#{xml.inspect}"
  end

  def assert_no_xml_tag(xml, conditions)
    doc = HTML::Document.new(xml)
    assert !doc.find(conditions), 
      "expected no tag, but found tag matching #{conditions.inspect} in:\n#{xml.inspect}"
  end
end
