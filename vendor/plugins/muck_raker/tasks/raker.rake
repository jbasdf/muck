namespace :muck do
  
  namespace :raker do

    namespace :db do
      desc "Flags the languages that the recommender supports"
      task :populate => :environment do
        require 'active_record/fixtures'
        ['en', 'es', 'zh-CN', 'fr', 'ja', 'de', 'ru', 'nl'].each{|l|
          r = Language.first(:one, :conditions => "locale = '#{l}'")
          if r
            r.update_attribute(:muck_raker_supported, true)
          else
            puts "Unable to find languages to flag. You probably need to run rake muck:db:populate"
            break
          end
        }
        # set up the defined services
        ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
        Fixtures.new(Service.connection,"services",Service,File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'db', 'bootstrap', 'services')).insert_fixtures
      end
    end

    desc "Sync files from recommender."
    task :sync do
      system "rsync -ruv vendor/plugins/recommender/db ." 
    end
    
    desc "Start the recommender daemon process"
    task :start => :environment do
      Dir.chdir(File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'raker', 'lib')) do
        jars = Dir['*.jar'].join(';')
        exec "java -Dsolr.solr.home=\"#{SOLR_HOME_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -classpath #{jars};. edu.usu.cosl.recommenderd.Recommender"  
      end
    end
    
    desc "Stop the recommender daemon process"
    task :stop do
      system "java"
    end
    
    desc "Restart the recommender daemon process"
    task :restart do
      system "java"
    end

  end  

end