Feature: Change Theme
  As a site administrator
  I want to be able to change the site wide theme
  
Scenario: Anonymous user tries to edit the theme
  Given I am not logged in
  When I go to "/admin/theme/edit"
  Then I should see the login
  
Scenario: Administrator user tries to edit the theme
  Given I log in with role "administrator"
  When I go to "/admin/theme/edit"
  Then I should see "Set Theme"