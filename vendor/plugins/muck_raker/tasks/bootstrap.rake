namespace :muck do
  namespace :raker do
    namespace :db do
      desc "Loads oai endpoints so we can get test data"
      task :bootstrap => :environment do
          require 'active_record/fixtures'
          ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    
          # import the bootstrap db entries
          OaiEndpoint.delete_all
          Fixtures.new(OaiEndpoint.connection,"oai_endpoints",OaiEndpoint,File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'db', 'bootstrap',"oai_endpoints")).insert_fixtures
          Feed.delete_all
          Fixtures.new(Feed.connection,"feeds",Feed,File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'db', 'bootstrap',"feeds")).insert_fixtures
      end
    end
  end
end

