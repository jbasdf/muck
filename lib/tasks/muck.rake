require 'fileutils'

namespace :muck do
  
  desc "Completely reset and repopulate the database and annotate models. THIS WILL DELETE ALL YOUR DATA"
  task :reset do
    
    puts 'syncronizing engines'
    system "rake cms_lite:setup"
    system "rake disguise:setup"
    system "rake uploader:sync"
    system "rake muck:base:sync"
    system "rake muck:users:sync"
    system "rake muck:activity:sync"
    system "rake recommender:sync"
    
    puts 'droping databases'
    system "rake db:drop:all"

    puts 'creating databases'
    system "rake db:create:all"

    puts 'migrating'
    system "rake db:migrate"

    puts 'populating'
    system "rake muck:db:populate"
    system "rake recommender:db:bootstrap"
    system "rake recommender:db:populate"
    
    puts 'setting up admin account'
    system "rake muck:users:create_admin"
    
    puts 'setting up test db'
    system "rake db:test:prepare"

    #puts 'annotating models'
    #system "annotate"
  end


  task :sync do
    puts 'syncronizing engines and gems'
    system "rake cms_lite:setup"
    system "rake disguise:setup"
    system "rake uploader:sync"
    system "rake muck:base:sync"
    system "rake muck:users:sync"
    system "rake muck:activity:sync"
    system "rake recommender:sync"
  end
  
  namespace :dev do
    task :gitpull do
      
    end
  end
end