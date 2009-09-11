ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckShare }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckSharer }
ActionController::Base.send :helper, MuckSharesHelper
I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]

Mime::Type.register "text/javascript", :pjs