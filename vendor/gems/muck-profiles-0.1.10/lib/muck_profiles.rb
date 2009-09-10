ActiveRecord::Base.class_eval { include ActiveRecord::Has::MuckProfile }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckProfile }
ActionController::Base.send :helper, MuckProfilesHelper

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]