namespace :recommender do
  namespace :db do
    desc "Loads oai endpoints so we can get test data"
    task :bootstrap => :environment do
        require 'active_record/fixtures'
        ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
  
        # import the bootstrap db entries
        Fixtures.new(OaiEndpoint.connection,"oai_endpoints",OaiEndpoint,File.join(RAILS_ROOT, 'vendor', 'plugins', 'recommender', 'db', 'bootstrap',"oai_endpoints")).insert_fixtures
    end
  end

  namespace :db do
    desc "Flags the languages that the recommender supports"
    task :populate => :environment do
      ['en', 'es', 'zh-CN', 'fr', 'ja', 'de', 'ru', 'nl'].each{|l|
        Language.first(:one, :conditions => "locale = '#{l}'").update_attribute(:muck_raker_supported, true)
      }
    end
  end
end

