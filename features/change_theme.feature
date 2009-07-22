Feature: Change Theme
  As a site administrator
  I want to be able to change the site wide theme
  
Scenario: Anonymous user tries to edit the theme
  Given I am not logged in
  When I go to "/admin/theme/edit"
  Then I should see the login
  
Scenario: Administrator edits the theme
  Given I log in with role "administrator"
  When I go to "/admin/theme/edit"
  Then I should see "Set Theme"
  
Scenario: Administrator changes the theme
  GivenScenario Administrator edits the theme
  Given The current theme is "blue"
  When I press "folksemantic"
  Then I should see "Theme was successfully updated."

Scenario: Administrator removes all themes
  GivenScenario Administrator changes the theme
  When I press "remove_all_themes"
  Then I should see "All themes have been removed."
  