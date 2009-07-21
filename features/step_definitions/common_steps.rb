PASSWORD = "asdfasdf"

def log_in_user(user, password)
  visit(login_url)
  fill_in("user_session_login", :with => user.login)
  fill_in("user_session_password", :with => PASSWORD)
  click_button("Sign In")
end

def log_in_with_login_and_role(login, role)
  @user = Factory(:user, :login => login, :password => PASSWORD, :password_confirmation => PASSWORD)
  @user.add_to_role(role)
  log_in_user(@user, PASSWORD)
end

def log_in_with_role(role)
  @user = Factory(:user, :password => PASSWORD, :password_confirmation => PASSWORD)
  @user.add_to_role(role)
  log_in_user(@user, PASSWORD)
end


Before do
  ActionMailer::Base.deliveries = []
end


# Assumes password is 'asdfasdf'
Given /I log in as "(.*)"/ do |login|
  @user = User.find_by_login(login)
  log_in_user(@user, PASSWORD)
end

Given /I log in as new user "(.*)" with password "(.*)"/ do |login, password|
  @user = Factory(:user, :login => login, :password => password, :password_confirmation => password)
  log_in_user(@user, password)
end

Given /I log in as new user/ do
  @user = Factory(:user, :password => PASSWORD, :password_confirmation => PASSWORD)
  log_in_user(@user, PASSWORD)
end

Given /^I log in with role "(.*)"$/ do |role|
  log_in_with_role(role)
end

Given /^I am not logged in$/ do
  post '/logout'
end

Then /^I should see the login$/ do
  response.body.should =~ /sign_in/m
  response.body.should =~ /user_session_login/m
  response.body.should =~ /user_session_password/m
end


#features/step_definitions/common_steps.rb
# On page/record
Given /^I am on "([^"]*)"$/ do |path|
  visit path
end

Then /^I should be on "([^"]*)"$/ do |path|
  current_path.should == path
end

Given /^I am on "([^"]*)" "([^"]*)"$/ do |model,number|
  visit polymorphic_path(record_from_strings(model,number))
end

Then /^I should be on "([^"]*)" "([^"]*)"$/ do |model,number|
   current_path.should == polymorphic_path(record_from_strings(model,number))
end

# Existing
Given /^a "([^"]*)" exists for "([^"]*)" "([^"]*)"$/ do |associated,model,number|
  record = record_from_strings(model,number)
  record.send(associated.underscore+'=',valid(associated))
  record.save!
end

# Support
def current_path
  response.request.request_uri
end

def record_from_strings(model,number)
  model.constantize.find(:first,:offset=>number.to_i-1)
end


