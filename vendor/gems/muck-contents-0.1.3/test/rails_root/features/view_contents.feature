Feature: View content page
  As a user
  I want to be able to view a page from the content system

# TODO can't browse to /about-us since it doesn't exist in the routes.  Figure out if there 

Scenario: Anonymous user visits the about us page in the root
  Given I am not logged in
  And There is a content page with the title "About Us" and the body "Hello World"
  When I browse to url "/about-us"
  Then dump response!
  Then I should see "Hello World"

# Scenario: Anonymous user visits nested page
#   Given I am not logged in
#   And There is a content page with the uri "/user/jbasdf/hi" and the body "Hello World"
#   When I browse to url "/user/jbasdf/hi"
#   Then I should see "Hello World"
#   And The page title should be 'hi'
#   
# Scenario: Anonymous user visits a page that does not exist
#   Given I am not logged in
#   When I browse to url "/a/page/that/does/not/exist"
#   Then I should see "404"
#   
# Scenario: Admin user visits a page that does not exist and is prompted to create a new page
#   Given I log in with role "administrator"
#   When I browse to url "/a/page/that/does/not/exist"
#   Then I should see "The page you requested does not exist.  Please provide the information below to create the page."
