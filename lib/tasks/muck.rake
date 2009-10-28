require 'rake'
begin
  require 'git'
rescue LoadError
  puts "git gem not installed.  If git functionality is required run 'sudo gem install git'"
end
require 'fileutils'

namespace :muck do
  
  def muck_gems
    ['cms-lite', 'disguise', 'uploader', 'muck-solr', 'muck-raker', 'muck-engine',
    'muck-users', 'muck-activities', 'muck-comments', 'muck-profiles', 'muck-friends',
    'muck-contents', 'muck-blogs', 'muck-shares', 'muck-invites', 'babelphish']
  end
  
  desc 'Translate muck and all themes from English into all languages supported by Google'
  task :translate => :environment do
    puts 'translating muck'
    system("babelphish -o -y #{RAILS_ROOT}/config/locales/en.yml")
    theme_path = File.join(RAILS_ROOT, 'themes')
    Dir.glob("#{theme_path}/*").each do |next_file|
      if File.directory?(next_file)
        file = File.join(next_file, 'locales', 'en.yml')
        system("babelphish -o -y #{file}")
      end
    end
  end

  desc "Translate all muck related projects and gems"
  task :translate_all do
    Rake::Task[ "muck:translate" ].execute
    Rake::Task[ "muck:translate_gems" ].execute
    puts 'finished translations'
  end
  
  desc "Gets everything ready for a release. Translates muck + gems, release gems, commits gems translates muck, writes versions into muck and then commits muck.  This takes a while"
  task :prepare_release do
    # Be sure to pull down all the latest code for each gem before a release
    # Rake::Task[ "muck:commit_gems" ].execute
    # Rake::Task[ "muck:pull_gems" ].execute
    Rake::Task[ "muck:translate_all" ].execute
    Rake::Task[ "muck:release_gems" ].execute
    Rake::Task[ "muck:commit_gems" ].execute
    Rake::Task[ "muck:push_gems" ].execute
    Rake::Task[ "muck:sync" ].execute
    Rake::Task[ "muck:versions" ].execute
    Rake::Task[ "muck:install_gems" ].execute
    # Commit and push muck
    git_commit("#{projects_path}/muck", "Updated gem versions")
    git_pull("#{projects_path}/muck")
    git_push("#{projects_path}/muck")
    puts "Don't forget to install the new gems on the server"
  end

end