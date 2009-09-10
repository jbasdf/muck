require 'rake'
begin
  require 'git'
rescue LoadError
  puts "git gem not installed.  If git functionality is required run 'sudo gem install git'"
end
require 'fileutils'

namespace :muck do
  
  GREEN = "\033[0;32m"
  RED = "\033[0;31m"
  BLUE = "\033[0;34m"
  INVERT = "\033[00m"

  def muck_gems
    ['cms-lite', 'disguise', 'uploader', 'muck-solr', 'muck-raker', 'muck-engine',
    'muck-users', 'muck-activities', 'muck-comments', 'muck-profiles', 'muck-friends',
    'muck-contents', 'muck-blogs', 'muck-shares'] #'muck-invites'
  end
  
  def muck_gem_paths
    muck_gems.collect{|name| name.sub('-', '_')}
  end
  
  desc "unpacks all muck gems into vendor/gems using versions installed on the local machine."
  task :unpack do
    gem_path = File.join(File.dirname(__FILE__), '..', '..', 'vendor', 'gems')
    FileUtils.mkdir_p(gem_path) unless File.exists?(gem_path)
    inside gem_path do
      muck_gems.each do |gem_name|
        system("gem unpack #{gem_name}")
        system("gem specification #{gem_name} > .specification")
      end
    end
  end
    
  desc "Install and unpacks all muck gems into vendor/gems."
  task :unpack_install => :install_gems do
    gem_path = File.join(File.dirname(__FILE__), '..', '..', 'vendor', 'gems')
    FileUtils.mkdir_p(gem_path) unless File.exists?(gem_path)
    inside gem_path do
      muck_gems.each do |gem_name|
        system("gem unpack #{gem_name}")
        system("gem specification #{gem_name} > .specification")
      end
    end
  end
  
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
  
  task :install_gems do
    muck_gems.each do |gem_name|
      system("sudo gem install #{gem_name}")
    end
  end
  
  task :sync do
    puts 'syncronizing engines and gems'
    Rake::Task[ "cms_lite:setup" ].execute
    Rake::Task[ "disguise:sync" ].execute
    Rake::Task[ "disguise:setup" ].execute
    Rake::Task[ "uploader:sync" ].execute
    Rake::Task[ "muck:engine:sync" ].execute
    Rake::Task[ "muck:users:sync" ].execute
    Rake::Task[ "muck:activities:sync" ].execute
    Rake::Task[ "muck:raker:sync" ].execute
    Rake::Task[ "muck:comments:sync" ].execute
    Rake::Task[ "muck:profiles:sync" ].execute
    Rake::Task[ "muck:friends:sync" ].execute
    Rake::Task[ "muck:contents:sync" ].execute
    Rake::Task[ "muck:blogs:sync" ].execute
    Rake::Task[ "muck:shares:sync" ].execute
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
  
  desc "Translate all muck related projects and gems"
  task :translate_all do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')

    puts 'translating muck'
    system("babelphish -o -y #{projects_path}/muck/config/locales/en.yml")

    muck_gem_paths.each do |gem_name|
      puts "translating #{gem_name}"
      system("babelphish -o -y #{projects_path}/#{gem_name}/locales/en.yml")
    end

    puts 'finished translations'
  end

  desc "Gets everything ready for a release. Translates muck + gems, release gems, commits gems translates muck, writes versions into muck and then commits muck.  This takes a while"
  task :prepare_release do
    # Rake::Task[ "muck:commit_gems" ].execute
    # Rake::Task[ "muck:pull_gems" ].execute
    Rake::Task[ "muck:translate_all" ].execute
    Rake::Task[ "muck:release_gems" ].execute
    Rake::Task[ "muck:commit_gems" ].execute
    Rake::Task[ "muck:push_gems" ].execute
    Rake::Task[ "muck:versions" ].execute
    # Commit and push muck
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    git_commit("#{projects_path}/muck", "Updated gem versions")
    git_pull("#{projects_path}/muck")
    git_push("#{projects_path}/muck")
    puts "Don't forget to install the new gems on the server"
  end
  
  desc "Release muck gems"
  task :release_gems do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    muck_gem_paths.each do |gem_name|
      release_gem("#{projects_path}", gem_name)
    end
  end

  desc "Write muck gem versions into muck"
  task :versions do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    muck_gem_paths.each do |gem_name|
      write_new_gem_version("#{projects_path}", gem_name)
    end
  end
    
  desc "commit gems after a release"
  task :commit_gems do
    message = "Released new gem"
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    muck_gem_paths.each do |gem_name|
      write_new_gem_version("#{projects_path}/#{gem_name}", message)
    end
  end
  
  desc "Pull code for all the gems (use with caution)"
  task :pull_gems do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    muck_gem_paths.each do |gem_name|
      git_pull("#{projects_path}/#{gem_name}")
    end
  end
  
  desc "Push code for all the gems (use with caution)"
  task :push_gems do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    muck_gem_paths.each do |gem_name|
      git_push("#{projects_path}/#{gem_name}")
    end
  end
  
  desc "Gets status for all the muck gems"
  task :status_gems do
    projects_path = File.join(File.dirname(__FILE__), '..', '..',  '..')
    muck_gem_paths.each do |gem_name|
      git_status("#{projects_path}/#{gem_name}")
    end
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
    puts "Commiting #{BLUE}#{File.basename(path)}#{INVERT}"
    repo = Git.open("#{path}")
    puts repo.add('.')
    puts repo.commit(message) rescue 'nothing to commit'
  end
  
  def git_push(path)
    puts "Pushing #{BLUE}#{File.basename(path)}#{INVERT}"
    repo = Git.open("#{path}")
    puts repo.push
  end
  
  def git_pull(path)
    puts "Pulling code for #{BLUE}#{File.basename(path)}#{INVERT}"
    repo = Git.open("#{path}")
    puts repo.pull
  end

  def git_status(path)
    repo = Git.open("#{path}")
    status = repo.status
    
    changed = (status.changed.length > 0 ? RED : GREEN) + "#{status.changed.length}#{INVERT}"
    untracked = (status.untracked.length > 0 ? RED : GREEN) + "#{status.untracked.length}#{INVERT}"
    added = (status.added.length > 0 ? RED : GREEN) + "#{status.added.length}#{INVERT}"
    deleted = (status.deleted.length > 0 ? RED : GREEN) + "#{status.deleted.length}#{INVERT}"
    puts "#{BLUE}#{File.basename(path)}:#{INVERT}  Changed(#{changed}) Untracked(#{untracked}) Added(#{added}) Deleted(#{deleted})"
    if status.changed.length > 0
      status.changed.each do |file|
        puts "    Changed: #{RED}#{file[1].path}#{INVERT}"
      end
    end
    # if status.untracked.length > 0
    #   status.untracked.each do |file|
    #     puts "    Untracked: #{RED}#{file[1].path}#{INVERT}"
    #   end
    # end
    # if status.added.length > 0
    #   status.added.each do |file|
    #     puts "    Added: #{RED}#{file[1].path}#{INVERT}"
    #   end
    # end
    if status.deleted.length > 0
      status.deleted.each do |file|
        puts "    Deleted: #{RED}#{file[1].path}#{INVERT}"
      end
    end
    puts ""
  end
  
  # execute commands in a different directory
  def inside(dir, &block)
    FileUtils.cd(dir) { block.arity == 1 ? yield(dir) : yield }
  end
  
end