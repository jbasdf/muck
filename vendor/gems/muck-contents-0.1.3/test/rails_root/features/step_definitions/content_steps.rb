Given /^There is content with title "(.*)" and body "(.*)" scoped to user "(.*)"$/ do |title, body, username|
  user = Factory(:user, :login => username)
  Factory(:content, :title => title, :body_raw => body, :contentable => user)
end

Given /^There is a content page with the title "(.*)" and the body "(.*)"$/ do |title, body|
  Factory(:content, :title => title, :body_raw => body, :contentable => nil)
  ActionController::Routing::Routes.reload!
end

Given /^There is a content page with the uri "(.*)" and the body "(.*)"$/ do |uri, body|
  content = Factory.build(:content, :body_raw => body, :contentable => nil)
  content.uri = uri
  content.save!
end
