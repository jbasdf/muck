Feature: View shares page
  As a user
  I want to be able to view and add shares
  
Scenario: Anonymous user visits the shares
  Given I am not logged in
  And There are shares
  When I go to "the show shares page"
  Then I should see "shares"
  
Scenario: Logged in user views add share
  Given I log in with role "administrator"
  When I go to "the create shares page"
  Then I should see "Add a new share"

Scenario: Add share
  GivenScenario: Logged in user views add share
  When I fill in "share_body" with "a test share"
  And I press "Add Share"
  Then I should see "added share"
  