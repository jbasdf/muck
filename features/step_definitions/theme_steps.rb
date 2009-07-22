Given /The current theme is "(.*)"/ do |name|
  Theme.delete_all
  Factory(:theme, :id => 1, :name => name)
end