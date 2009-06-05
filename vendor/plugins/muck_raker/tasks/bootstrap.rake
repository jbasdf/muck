namespace :muck do
  namespace :raker do
    namespace :db do
      desc "Loads oai endpoints so we can get test data"
      task :bootstrap => :environment do
          require 'active_record/fixtures'
          ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    
          # import the bootstrap db entries
          Fixtures.new(OaiEndpoint.connection,"oai_endpoints",OaiEndpoint,File.join(RAILS_ROOT, 'vendor', 'plugins', 'recommender', 'db', 'bootstrap',"oai_endpoints")).insert_fixtures
      end
    end
  end
end

