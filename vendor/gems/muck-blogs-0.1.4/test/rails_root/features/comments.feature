Feature: View blogs page
  As a user
  I want to be able to view and add blogs
  
Scenario: Anonymous user visits the blogs
  Given I am not logged in
  And There are blogs
  When I go to "the show blogs page"
  Then I should see "blogs"
  
Scenario: Logged in user views add blog
  Given I log in with role "administrator"
  When I go to "the create blogs page"
  Then I should see "Add a new blog"

Scenario: Add blog
  GivenScenario: Logged in user views add blog
  When I fill in "blog_body" with "a test blog"
  And I press "Add Blog"
  Then I should see "added blog"
  