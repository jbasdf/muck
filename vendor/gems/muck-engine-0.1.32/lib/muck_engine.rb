
ActionController::Base.send :include, ActionController::MuckApplication
ActiveRecord::Base.send :include, ActiveRecord::MuckModel
ActionController::Base.send :helper, MuckEngineHelper

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]