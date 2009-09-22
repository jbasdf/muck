# lib/tasks/deadweight.rake
# see 
# http://github.com/aanand/deadweight
# and
# http://railscasts.com/episodes/180-finding-unused-css
begin
  require 'deadweight'
rescue LoadError
end

desc "run Deadweight CSS check (requires script/server)"
task :deadweight do
  dw = Deadweight.new
  
  dw.mechanize = true
  #dw.root = 'http://staging.example.com'
  
  dw.stylesheets = ["/stylesheets/folksemantic.css", "/stylesheets/styles.css"]
  dw.pages = ["/", "/feeds", "/signup", "/widgets"]

  dw.pages << proc {
    fetch('/login')
    form = agent.page.form('sign_in_form')
    form['user_session[login]'] = 'admin'
    form['user_session[password]'] = 'asdfasdf'
    agent.submit(form)
    fetch('/users/admin')
    fetch('/resources')
    fetch('/resources/tags/activity programs?grain_size=all')
  }

  dw.ignore_selectors = /flash_notice|flash_error|errorExplanation|fieldWithErrors|.*jGrowl.*/
  puts dw.run
end