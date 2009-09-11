Feature: View, add and edit feeds
  As a user
  I want to be able to manage feeds
  
Scenario: Anonymous user visits the feeds index page
  Given I am not logged in
  When I go to "the public feed index"
  Then I should see "Registered Collections"
  
Scenario: Admin user visits a page that does not exist and is prompted to create a new page
  Given I log in with role "administrator"
  When I go to "the feed admin page"
  Then I should see "Registered Collections"
