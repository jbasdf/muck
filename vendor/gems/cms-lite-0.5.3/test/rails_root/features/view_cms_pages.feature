Feature: CMS Lite
  As a user
  I want to be able to view cms lite pages 
  And have them served using Rails so that they will have the website chrome
  
Scenario: Anonymous user visits public cms lite page
  Given cms lite file "content/pages/en/open/hello.html.erb" contains "hello world"
  And I am not logged in
  When I go to "/open/hello"
  Then I should see "hello world"

Scenario: Anonymous user visits root public page
  Given cms lite file "content/pages/en/default/root.html.erb" contains "hello from the root"
  And I am not logged in
  When I go to "/root"
  Then I should see "hello from the root"
  
Scenario: Anonymous user visits public cms lite page in blue theme
  Given cms lite file "themes/blue/content/pages/en/open/blue.htm" contains "blue world"
  And I am not logged in
  When I go to "/open/blue"
  Then I should see "blue world"

Scenario: Anonymous user visits public root page in blue theme
  Given cms lite file "themes/blue/content/pages/en/default/blue_root.html" contains "blue root"
  And I am not logged in
  When I go to "/blue_root"
  Then I should see "blue root"
      
Scenario: Anonymous user visits protected cms lite page
  Given protected cms lite file "content/protected-pages/en/protected/safe-hello.html.erb" contains "protect hello world"
  And I am not logged in
  When I go to "/protected/safe-hello"
  Then I should see the login
	And I should see a "notice" flash message

Scenario: Logged in user visits protected cms lite page
  Given protected cms lite file "content/protected-pages/en/protected/safe-hello.html.erb" contains "protect hello world"
  And I log in as new user
  When I go to "/protected/safe-hello"
  Then I should see "protect hello world"

Scenario: Logged in user visits protected cms lite page in red theme
  Given protected cms lite file "themes/red/content/protected-pages/en/red/red.html.erb" contains "protect red world"
  And I log in as new user
  When I go to "/red/red"
  Then I should see "protect red world"
