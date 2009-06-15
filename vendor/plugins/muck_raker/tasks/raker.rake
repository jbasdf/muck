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
      separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
      Dir.chdir(File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'raker', 'lib')) do
        jars = Dir['*.jar'].join(separator)
        exec "java -Dsolr.solr.home=\"#{SOLR_HOME_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -classpath #{jars}#{separator}. edu.usu.cosl.recommenderd.Recommender"  
      end
    end
    
    desc "Harvest without recommending"
    task :harvest => :environment do
      separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
      Dir.chdir(File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'raker', 'lib')) do
        jars = Dir['*.jar'].join(separator)
        exec "java -Dsolr.solr.home=\"#{SOLR_HOME_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -classpath #{jars}#{separator}. edu.usu.cosl.aggregatord.Harvester"  
      end
    end
 
    desc "Recommend without harvesting"
    task :recommend => :environment do
      separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
      Dir.chdir(File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'raker', 'lib')) do
        jars = Dir['*.jar'].join(separator)
        exec "java -Dsolr.solr.home=\"#{SOLR_HOME_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -classpath #{jars}#{separator}. edu.usu.cosl.recommenderd.Recommender skip_harvest"  
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