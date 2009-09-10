Feature: View the visit page
  As a user
  I want to be able to view external pages within a frame

Scenario: Anonymous user visits the feeds index page
  Given I am not logged in
  And There is an entry in the database
  When I go to "the visit resource page"
  Then I should see "Share"
  And I should see "Comment"