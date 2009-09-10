Feature: View comments page
  As a user
  I want to be able to view and add comments
  
Scenario: Anonymous user visits the comments
  Given I am not logged in
  And There are comments
  When I go to "the show comments page"
  Then I should see "comments"
  
Scenario: Logged in user views add comment
  Given I log in with role "administrator"
  When I go to "the create comments page"
  Then I should see "Add a new comment"

Scenario: Add comment
  GivenScenario: Logged in user views add comment
  When I fill in "comment_body" with "a test comment"
  And I press "Add Comment"
  Then I should see "added comment"
  