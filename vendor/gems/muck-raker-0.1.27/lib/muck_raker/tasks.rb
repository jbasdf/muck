require 'rake'
require 'rake/tasklib'
require 'fileutils'

module MuckRaker
  class Tasks < ::Rake::TaskLib
    def initialize
      define
    end
  
    private
    def define
      
      namespace :muck do

        namespace :raker do

          desc "Imports attention data for use in testing"
          task :import_attention => :environment do
            require 'active_record/fixtures'
            ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
            yml = File.join(RAILS_ROOT, 'db', 'bootstrap', 'attention')
            Fixtures.new(Attention.connection,"attention",Attention,yml).insert_fixtures
          end

          namespace :db do

            desc "Flags the languages that the muck raker supports"
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
            end
            
            desc "Loads some feeds oai endpoints to get things started"
            task :bootstrap => :environment do
              require 'active_record/fixtures'
              ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

              # import the bootstrap db entries
              OaiEndpoint.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"oai_endpoints")
              Fixtures.new(OaiEndpoint.connection,"oai_endpoints",OaiEndpoint,yml).insert_fixtures

              Feed.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"feeds")
              Fixtures.new(Feed.connection,"feeds",Feed,yml).insert_fixtures

              ServiceCategory.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"service_categories")
              Fixtures.new(Service.connection,"service_categories",ServiceCategory,yml).insert_fixtures
              
              Service.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"services")
              Fixtures.new(Service.connection,"services",Service,yml).insert_fixtures

            end

            desc "Deletes and reloads all services and service categories"
            task :bootstrap_services => :environment do
              require 'active_record/fixtures'
              ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

              ServiceCategory.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"service_categories")
              Fixtures.new(Service.connection,"service_categories",ServiceCategory,yml).insert_fixtures
              
              Service.delete_all
              yml = File.join(File.dirname(__FILE__), '..', '..', 'db', 'bootstrap',"services")
              Fixtures.new(Service.connection,"services",Service,yml).insert_fixtures

            end
            
          end
 
          desc "Sync files from muck raker."
          task :sync do
            path = File.join(File.dirname(__FILE__), *%w[.. ..])
            system "rsync -ruv #{path}/db ."
            system "rsync -ruv #{path}/public ."
            system "rsync -ruv #{path}/config/solr ./config"
          end
          
          desc "Harvest without recommending"
          task :harvest => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              javaclass = "edu.usu.cosl.aggregatord.Harvester"
              cmd = "java " + options + classpath + javaclass
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
            end
          end

          desc "Start the recommender daemon process"
          task :start => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              javaclass = "edu.usu.cosl.recommenderd.Recommenderd"
              cmd = "java " + options + classpath + javaclass
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
            end
          end

          desc "Reindex records"
          task :reindex => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              memory_options = "-Xms32m -Xmx128m "
              javaclass = "edu.usu.cosl.indexer.Indexer "
              cmdlineoption = "all "
              cmd = "java " + options + classpath + memory_options + javaclass + cmdlineoption
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
            end
          end

          desc "Autogenerate subjects"
          task :gen_subjects => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              javaclass = "edu.usu.cosl.tagclouds.SubjectAutoGenerator "
              cmd = "java " + options + classpath + javaclass
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
            end
          end

          desc "Generate tag clouds"
          task :gen_clouds => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              javaclass = "edu.usu.cosl.tagclouds.TagCloud"
              cmd = "java " + options + classpath + javaclass
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
            end
          end

          desc "Recommend without harvesting"
          task :recommend => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              javaclass = "edu.usu.cosl.recommenderd.Recommenderd "
              cmdlineoption = "skip_harvest "
              cmd = "java " + options + classpath + javaclass + cmdlineoption
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
            end
          end

          desc "Rebuild entry recommendation caches"
          task :rebuild_recommendation_cache => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              javaclass = "edu.usu.cosl.recommender.Recommender "
              cmdlineoption = "rebuild_cache "
              cmd = "java " + options + classpath + javaclass + cmdlineoption
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
            end
          end

          desc "Redo everything (re-index, redo autogenerated subjects, rebuild tag clouds re-recommend)"
          task :rebuild => :environment do
            require File.expand_path("#{File.dirname(__FILE__)}/../../config/muck_raker_environment")
            separator = (RUBY_PLATFORM =~ /(win|w)32$/ ? ';' : ':')
            puts "RAILS_ENV=" + ENV['RAILS_ENV']
            Dir.chdir(File.join(File.dirname(__FILE__), '../../', 'raker', 'lib')) do
              jars = Dir['*.jar'].join(separator)
              options = "-Dsolr.solr.home=\"#{SOLR_CONFIG_PATH}\" -Dsolr.data.dir=\"#{SOLR_DATA_PATH}\" -DRAILS_ENV=#{ENV['RAILS_ENV']} -DRAILS_DB_CONFIG=\"#{RAILS_DB_CONFIG}\" -DLOG_FILE_PREFIX=\"#{LOG_FILE_PREFIX}\" "
              options << "-DDEBUG=true " unless ENV['DEBUG'] == 'false'
              options << "-DLOG_TO_CONSOLE=true " unless ENV['DEBUG'] == 'false'
              options << "-DFEED_ARCHIVE_PATH=\"#{FEED_ARCHIVE_PATH}\" "
              classpath = "-classpath #{jars}#{separator}. "
              javaclass = "edu.usu.cosl.recommenderd.Recommenderd "
              cmdlineoption = "rebuild "
              cmd = "java " + options + classpath + javaclass + cmdlineoption
              puts ("Executing: " + cmd) if ENV['DEBUG']
              exec cmd  
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

    end
  end
end
MuckRaker::Tasks.new