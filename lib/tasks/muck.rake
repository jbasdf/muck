require 'fileutils'

namespace :muck do
  
  desc "Completely reset and repopulate the database and annotate models. THIS WILL DELETE ALL YOUR DATA"
  task :reset => :environment do
    
    puts 'syncronizing engines'
    Rake::Task[ "cms_lite:setup" ].execute
    Rake::Task[ "disguise:setup" ].execute
    Rake::Task[ "uploader:sync" ].execute
    Rake::Task[ "muck:base:sync" ].execute
    Rake::Task[ "muck:users:sync" ].execute
    Rake::Task[ "muck:activities:sync" ].execute
    Rake::Task[ "muck:raker:sync" ].execute
    Rake::Task[ "muck:comments:sync" ].execute
    Rake::Task[ "muck:profiles:sync" ].execute

    puts 'droping databases'
    Rake::Task[ "db:drop" ].execute

    puts 'creating databases'
    Rake::Task[ "db:create" ].execute

    puts 'migrating'
    Rake::Task[ "db:migrate" ].execute

    puts 'populating'
    Rake::Task[ "muck:db:populate" ].execute
    Rake::Task[ "muck:raker:db:bootstrap" ].execute
    Rake::Task[ "muck:raker:db:populate" ].execute
    
    puts 'setting up admin account'
    Rake::Task[ "muck:users:create_admin" ].execute
    
    puts 'setting up test db'
    Rake::Task[ "db:test:prepare" ].execute

  end
  
  task :reset_db => :environment do
    
    puts 'droping databases'
    Rake::Task[ "db:drop" ].execute

    puts 'creating databases'
    Rake::Task[ "db:create" ].execute

    puts 'migrating'
    Rake::Task[ "db:migrate" ].execute

    puts 'populating db with locale info'
    Rake::Task[ "muck:db:populate" ].execute
    
    puts 'flagging the languages muck raker supports and adding services it supports'
    Rake::Task[ "muck:raker:db:populate" ].execute

    puts 'adding some oai endpoints and feeds to the db'
    Rake::Task[ "muck:raker:db:bootstrap" ].execute
    
    puts 'setting up admin account'
    Rake::Task[ "muck:users:create_admin" ].execute
    
#    puts 'setting up test db'
#    Rake::Task[ "db:test:prepare" ].execute

    #puts 'annotating models'
    #system "annotate"
  end

  desc "populates the database with all required values"
  task :setup_db => :environment do
    puts 'populating db with locale info'
    Rake::Task[ "muck:db:populate" ].execute
    Rake::Task[ "muck:raker:db:populate" ].execute
    Rake::Task[ "muck:raker:db:bootstrap" ].execute
    
    puts 'setting up admin account'
    Rake::Task[ "muck:users:create_admin" ].execute
  end
  
  task :sync do
    puts 'syncronizing engines and gems'
    Rake::Task[ "cms_lite:setup" ].execute
    Rake::Task[ "disguise:sync" ].execute
    Rake::Task[ "disguise:setup" ].execute
    Rake::Task[ "uploader:sync" ].execute
    Rake::Task[ "muck:base:sync" ].execute
    Rake::Task[ "muck:users:sync" ].execute
    Rake::Task[ "muck:activities:sync" ].execute
    Rake::Task[ "muck:raker:sync" ].execute
    Rake::Task[ "muck:comments:sync" ].execute
    Rake::Task[ "muck:profiles:sync" ].execute
  end
  
  task :import_attention => :environment do
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    yml = File.join(RAILS_ROOT, 'db', 'bootstrap', 'attention')
    Fixtures.new(Attention.connection,"attention",Attention,yml).insert_fixtures
  end
  
end