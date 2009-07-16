Feature: Home Page
  As a user
  I want to be able to view the home page
  
Scenario: Anonymous user visits the home page
  Given I am not logged in
  When I go to "/"
  Then I should see "muck"