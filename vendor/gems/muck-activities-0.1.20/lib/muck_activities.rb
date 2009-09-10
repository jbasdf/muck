require 'cgi'
require 'muck_activities/initialize_routes'
require 'muck_activities/muck_activity_sources'

ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckActivity }
ActionController::Base.send :helper, MuckActivityHelper
ActiveRecord::Base.send(:include, MuckActivitySources)
ActionController::Base.send(:include, MuckActivitySources)

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]