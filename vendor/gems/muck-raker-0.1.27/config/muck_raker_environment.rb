ENV['RAILS_ENV'] = (ENV['RAILS_ENV'] || 'development').dup
dir = File.dirname(__FILE__)
SOLR_PATH = File.expand_path("#{dir}/../solr") unless defined? SOLR_PATH

unless defined? SOLR_LOGS_PATH
  SOLR_LOGS_PATH = ENV["SOLR_LOGS_PATH"] || "#{RAILS_ROOT}/log"
end
unless defined? SOLR_PIDS_PATH
  SOLR_PIDS_PATH = ENV["SOLR_PIDS_PATH"] || "#{RAILS_ROOT}/tmp/pids"
end
unless defined? SOLR_DATA_PATH
  SOLR_DATA_PATH = ENV["SOLR_DATA_PATH"] || "#{RAILS_ROOT}/solr/#{ENV['RAILS_ENV']}"
end
unless defined? SOLR_CONFIG_PATH
  SOLR_CONFIG_PATH = ENV["SOLR_CONFIG_PATH"] || SOLR_PATH
end

unless defined? RAILS_DB_CONFIG
  if ENV['RAILS_ENV'] == 'production'
    RAILS_DB_CONFIG = File.join(RAILS_ROOT, '..', '..', 'shared', 'config', 'database.yml')
  else
    RAILS_DB_CONFIG = File.join(RAILS_ROOT, 'config', 'database.yml')
  end
end
unless defined? FEED_ARCHIVE_PATH
  if ENV['RAILS_ENV'] == 'production'
    FEED_ARCHIVE_PATH = File.join(RAILS_ROOT, '..', '..', 'shared', 'feed_archive')
  elsif ENV['RAILS_ENV'] == 'development'
    FEED_ARCHIVE_PATH = File.join(RAILS_ROOT, '..', 'feed_archive')
  else
    FEED_ARCHIVE_PATH = File.join(RAILS_ROOT, '..', 'feed_archive')
  end
end
unless defined? LOG_FILE_PREFIX
  LOG_FILE_PREFIX = File.join(RAILS_ROOT, 'log', 'muck_raker')
end