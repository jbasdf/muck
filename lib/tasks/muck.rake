require 'rake'
require 'git'
require 'fileutils'

namespace :muck do
  
  desc 'Translate muck and all themes from English into all languages supported by Google'
  task :translate do
    file = File.join(File.dirname(__FILE__), '..', '..', 'config', 'locales', 'en.yml')
    system("babelphish -o -y #{file}")
    # translate themes as well
    theme_path = File.join(File.dirname(__FILE__), '..', '..', 'themes')
    Dir.glob("#{theme_path}/*").each do |next_file|
      if File.directory?(next_file)
        file = File.join(next_file, 'locales', 'en.yml')
        system("babelphish -o -y #{file}")
      end
    end
    
  end
  
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
  
  task :install_gems do
    system('sudo gem install cucumber')
    system('sudo gem install cms-lite')
    system('sudo gem install disguise')
    system('sudo gem install uploader')
    system('sudo gem install muck-solr')
    system('sudo gem install muck-raker')
    system('sudo gem install muck-engine')
    system('sudo gem install muck-users')
    system('sudo gem install muck-activities')
    system('sudo gem install muck-comments')
    system('sudo gem install muck-profiles')
    system('sudo gem install muck-friends')
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
    Rake::Task[ "muck:friends:sync" ].execute
    Rake::Task[ "muck:contents:sync" ].execute
    Rake::Task[ "muck:blogs:sync" ].execute
  end
  
  desc "Translate all muck related projects and gems"
  task :translate_all do
    projects_path = File.join(File.dirname(__FILE__), '..')
    
    puts 'translating cms lite'
    system("babelphish -o -y #{projects_path}/cms_lite/locales/en.yml")
    
    puts 'translating disguise'
    system("babelphish -o -y #{projects_path}/disguise/locales/en.yml")
    
    puts 'translating uploader'
    system("babelphish -o -y #{projects_path}/uploader/locales/en.yml")
    
    puts 'translating muck'
    system("babelphish -o -y #{projects_path}/muck/config/locales/en.yml")

    puts 'translating muck engine'
    system("babelphish -o -y #{projects_path}/muck_engine/locales/en.yml")
    
    puts 'translating muck users'
    system("babelphish -o -y #{projects_path}/muck_users/locales/en.yml")
    
    puts 'translating muck comments'
    system("babelphish -o -y #{projects_path}/muck_comments/locales/en.yml")
    
    puts 'translating muck profiles'
    system("babelphish -o -y #{projects_path}/muck_profiles/locales/en.yml")
    
    puts 'translating muck raker'
    system("babelphish -o -y #{projects_path}/muck_raker/locales/en.yml")
    
    puts 'translating muck activities'
    system("babelphish -o -y #{projects_path}/muck_activities/locales/en.yml")
    
    puts 'translating muck friends'
    system("babelphish -o -y #{projects_path}/muck_friends/locales/en.yml")
    
    puts 'finished translations'
  end

  desc "Release muck gems"
  task :release do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    release_gem("#{projects_path}", "cms_lite")
    release_gem("#{projects_path}", "disguise")
    release_gem("#{projects_path}", "uploader")
    release_gem("#{projects_path}", "muck_engine")
    release_gem("#{projects_path}", "muck_users")
    release_gem("#{projects_path}", "muck_comments")
    release_gem("#{projects_path}", "muck_profiles")
    release_gem("#{projects_path}", "muck_raker")
    release_gem("#{projects_path}", "muck_activities")
    release_gem("#{projects_path}", "muck_friends")
  end
  
  desc "Write muck gem versions into muck"
  task :versions do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    write_new_gem_version("#{projects_path}", "cms_lite")
    write_new_gem_version("#{projects_path}", "disguise")
    write_new_gem_version("#{projects_path}", "uploader")        
    #write_new_gem_version("#{projects_path}", "acts_as_solr") # need to figure out version for this
    write_new_gem_version("#{projects_path}", "muck_engine")
    write_new_gem_version("#{projects_path}", "muck_users")
    write_new_gem_version("#{projects_path}", "muck_comments")
    write_new_gem_version("#{projects_path}", "muck_profiles")
    write_new_gem_version("#{projects_path}", "muck_raker")
    write_new_gem_version("#{projects_path}", "muck_activities")
    write_new_gem_version("#{projects_path}", "muck_friends")
  end
    
  desc "commit gems after a release"
  task :commit do
    message = "Released new gem"
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    git_commit("#{projects_path}/cms_lite", message)
    git_commit("#{projects_path}/disguise", message)
    git_commit("#{projects_path}/uploader", message)
    git_commit("#{projects_path}/muck_engine", message)
    git_commit("#{projects_path}/muck_users", message)
    git_commit("#{projects_path}/muck_comments", message)
    git_commit("#{projects_path}/muck_profiles", message)
    git_commit("#{projects_path}/muck_raker", message)
#    git_commit("#{projects_path}/acts_as_solr", message)
    git_commit("#{projects_path}/muck_activities", message)
    git_commit("#{projects_path}/muck_friends", message)
  end
  
  def release_gem(path, gem_name)
    gem_path = File.join(path, gem_name)
    puts "releasing #{gem_name}"
    inside gem_path do
      if File.exists?('pkg/*')
        puts "attempting to delete files from pkg.  Results #{system("rm pkg/*")}"
      end
      puts system("rake version:bump:patch")
      system("rake gemspec")
      puts system("rake rubyforge:release")
    end
    write_new_gem_version(path, gem_name)
  end

  def write_new_gem_version(path, gem_name)
    muck_path = File.join(path, 'muck')
    gem_path = File.join(path, gem_name)
    env_file = File.join(muck_path, 'config', 'environment.rb')
    version = IO.read(File.join(gem_path, 'VERSION')).strip
    environment = IO.read(env_file)
    search = Regexp.new('\:lib\s+=>\s+\'' + gem_name + '\',\s+\:version\s+=>\s+[\'\"][ <>=~]*\d+\.\d+\.\d+[\'\"]')
    if environment.gsub!(search, ":lib => '#{gem_name}', :version => '>=#{version}'").nil?
      search = Regexp.new('config.gem\s+\'' + gem_name + '\',\s+\:version\s+=>\s+[\'\"][ <>=~]*\d+\.\d+\.\d+[\'\"]')
      environment.gsub!(search, "config.gem '#{gem_name}', :version => '>=#{version}'")
    end
    
    File.open(env_file, 'w') { |f| f.write(environment) }
  end
  
  def git_commit(path, message)
    puts "*** pushing and commiting #{path} ***"
    repo = Git.open("#{path}")
    puts repo.add('.')
    puts repo.commit(message) rescue 'nothing to commit'
    puts repo.pull
    puts repo.push
  end
  
  # execute commands in a different directory
  def inside(dir, &block)
    FileUtils.cd(dir) { block.arity == 1 ? yield(dir) : yield }
  end
  
end