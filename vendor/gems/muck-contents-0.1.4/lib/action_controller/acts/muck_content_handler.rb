module ActionController
  module Acts #:nodoc:
    module MuckContentHandler #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_muck_content_handler
          rescue_from ActionController::RoutingError, :with => :handle_content_request
          include ActionController::Acts::MuckContentHandler::InstanceMethods
          
        end
      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_content</tt> specified.
      module InstanceMethods
        
        protected

          # Renders content, shows 404 or redirects to new content as appropriate
          def handle_content_request
            if !request.format.html?
              # If the the request is html we can bail.
              render :nothing => true, :status => 404
              return
            end
            get_content
            if @content.blank?
              redirect_to new_content_path(:path => request.path)
            else
              return if ensure_current_url
              render_show_content
            end
          end

          # Renders the show template with the current content.
          def render_show_content
            activate_authlogic # HACK authlogic isn't turned on for the application controller so we force it
            @page_title = @content.locale_title(I18n.locale)
            respond_to do |format|
              format.html do
                if @content.layout.blank?
                  render :template => 'contents/show'
                else
                  render :template => 'contents/show', :layout => @content.layout
                end
              end
              format.xml  { render :xml => @content }
            end
          end
          
          # Checks to see if the content has a better url.  If it does a redirect is performed and true is returned.
          # If not redirect then false is returned.
          def ensure_current_url
            # TODO right now in the routes we setup each page to be found via numeric id which triggers has_better_id?
            # In addition url_for(@content) adds 'contents' to the path.  Need to figure out how to generate the uri
            # when url_for(@content) is called or change to @content.uri and how to take advantage of the slug history which
            # helps us setup permanent redirects

            # might be time to add to the docs to setup a default route in routes.rb which maps everything that's not 
            # found to the contents controller. - map.connect '*url', :controller => 'pages', :action => 'show'
            # this could replace acts_as_muck_content_handler or we could just handle everything via acts_as_muck_content_handler 
            if @content.has_better_id?
              redirect_to @content, :status => :moved_permanently
              true
            else
              false
            end
          end

          # Tries to find content using parameters from the url
          def get_content
            return if @content # in case @content is setup by an overriding method
            id = params[:id] || Content.id_from_uri(request.path)
            scope = params[:scope] || Content.scope_from_uri(request.path)
            @content = Content.find(id, :scope => scope) rescue nil
            if @content.blank?
              @contentable = get_parent
              if @contentable
                @content = Content.find(params[:id], :scope => Content.contentable_to_scope(@contentable)) rescue nil
              end
            end
          end
          
      end
    end
  end
end
