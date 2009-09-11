require 'muck_users/exceptions'
require 'active_record/secure_methods'

ActionController::Base.send :include, ActionController::AuthenticApplication
ActiveRecord::Base.send :include, ActiveRecord::SecureMethods
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckUser }
ActiveRecord::Base.class_eval { include MuckUsers::Exceptions }
ActionController::Base.send :helper, MuckUsersHelper

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]
