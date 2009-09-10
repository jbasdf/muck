ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckContent }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckContentPermission }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckContentTranslation }
ActionController::Base.class_eval { include ActionController::Acts::MuckContentHandler }

ActionController::Base.send :helper, MuckContentsHelper
I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]

Mime::Type.register "text/javascript", :pjs

module MuckContents

  GLOBAL_SCOPE = '/'

  class << self
  
    def routes
      content_routes = []
      contents = Content.no_contentable.find(:all, :include => 'slugs')
      contents.each do |content|
        content_route = { :uri => content.uri,
                          :scope => content.scope,
                          :id => content.id }
        if !content_routes.include?(content_route)
          content_routes << content_route
        end
      end
      content_routes
    end
  
    def build_route_options(route)
      options = { :controller => 'contents', :action => 'show', :id => route[:id], :scope => route[:scope] }
      options
    end
  
  end
  
end