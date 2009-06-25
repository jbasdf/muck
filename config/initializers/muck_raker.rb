SOLR_CONFIG_PATH = "#{RAILS_ROOT}/config/solr"
SOLR_LOGS_PATH = "#{RAILS_ROOT}/log"
SOLR_PIDS_PATH = "#{RAILS_ROOT}/tmp/pids"
if ENV['RAILS_ENV'] == "production"
  SOLR_DATA_PATH = "#{RAILS_ROOT}/../../shared/solr_indexes"
else
  SOLR_DATA_PATH = "#{RAILS_ROOT}/../solr_indexes"
end
