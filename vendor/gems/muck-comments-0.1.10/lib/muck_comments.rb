require 'acts_as_commentable_with_threading'

ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckComment }
ActionController::Base.send :helper, MuckCommentsHelper
I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]

Mime::Type.register "text/javascript", :pjs