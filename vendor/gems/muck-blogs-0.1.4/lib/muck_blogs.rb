ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckBlog }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckBlogable }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckPost }
ActionController::Base.send :helper, MuckBlogsHelper
I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]

Mime::Type.register "text/javascript", :pjs