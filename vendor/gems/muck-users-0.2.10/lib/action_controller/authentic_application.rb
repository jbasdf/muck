module ActionController
    
  module AuthenticApplication
    
    # Module automatically mixed into the all controllers
    def self.included(base)
      base.class_eval do
        include InstanceMethods
      end
      # Inclusion hook to make #current_user and #logged_in?, etc available as ActionView helper methods.
      base.send :helper_method, :current_user_session, :current_user, :logged_in?, :admin?, :is_me?, :is_owner?
      base.send :filter_parameter_logging, :password, :password_confirmation
    end
        
    module InstanceMethods
      
      protected
      
      # Returns true or false if the user is logged in.
      def logged_in?
        !current_user.blank?
      end

      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end

      def current_user
        return @current_user if defined?(@current_user)
        @current_user = current_user_session && current_user_session.record
      end

      def login_required
        unless logged_in?
          store_location
          flash[:notice] = I18n.t('muck.users.login_requred')
          redirect_to login_path
        end
      end

      def not_logged_in_required
        if logged_in?
          store_location
          flash[:notice] = t('muck.users.logout_required')
          enforce_logout_required
        end
      end
      
      def check_role(role)
        unless logged_in? && current_user.has_role?(role)
          if logged_in?
            permission_denied
          else
            store_referer
            access_denied
          end
        end
      end

      def admin?
        logged_in? && current_user.admin?
      end    

      # check to see if the current user is the owner of the specified object
      def is_owner?(obj)
        obj.user_id == current_user.id
      end
      
      def is_owner?(user, user_id)
        user.id == user_id
      end
      
      # check to see if the given user is the same as the current user
      def is_me?(user)
        user == current_user
      end

      # checks permissions on an object.  Redirects if the current user
      # doesn't own it or have admin rights
      def protect_owner(obj)
        if is_owner?(obj) || admin?
          true
        else
          permission_denied
          false
        end
      end

      # allow or deny access depending on options specified
      def allowed_access?(options)
        if !options[:owner].nil? && !options[:object_user_id].nil?
          return true if is_owner?(options[:owner], options[:object_user_id])
        end

        options[:permit_roles].each do |role|
          return true if current_user.has_role?(role)
        end

        # access denied
        permission_denied
        false 
      end

      def can_access?(user, object, roles, &block)
        if logged_in? && user.is_in_role?(event, roles)
          content = capture(&block)
          concat(content, block.binding)
        end
      end

      def is_mine?(user, &block)
        if logged_in? && (current_user.id == user.id)
          content = capture(&block)
          concat(content, block.binding)
        end 
      end

      # Redirect as appropriate when an access request fails.
      #
      # The default action is to redirect to the login screen.
      #
      # Override this method in your controllers if you want to have special
      # behavior in case the user is not authorized
      # to access the requested action.  For example, a popup window might
      # simply close itself.
      def access_denied
        respond_to do |format|
          format.html do
            store_location
            flash[:error] = I18n.t('muck.users.access_denied')
            redirect_to login_path
          end
          format.xml do
            request_http_basic_authentication 'Web Password'
          end
        end
      end

      def permission_denied      
        respond_to do |format|
          format.html do
            domain_name = GlobalConfig.application_url
            raise t('muck.users.application_base_url_not_set') if domain_name.blank?
            http_referer = session[:refer_to]
            if http_referer.nil?
              store_referer
              http_referer = ( session[:refer_to] || domain_name )
            end
            flash[:error] = I18n.t('muck.users.permission_denied')
            if http_referer[0..domain_name.length] != domain_name
              session[:refer_to] = nil
              redirect_to root_path
            else
              redirect_to_referer_or_default(root_path)  
            end
          end
          format.xml do
            headers["Status"]           = "Unauthorized"
            headers["WWW-Authenticate"] = %(Basic realm="Web Password")
            render :text => I18n.t('muck.users.permission_denied'), :status => '401 Unauthorized'
          end
          format.js do
            render :text => I18n.t('muck.users.permission_denied')
          end
        end
      end

      def enforce_logout_required
        respond_to do |format|
          format.html do
            redirect_to current_user
          end
        end
      end
      
      # Store the URI of the current request in the session.
      # We can return to this location by calling #redirect_back_or_default.
      # Only store html requests so we don't redirect a user back to and rss or xml feed
      def store_location
        if request.format == :html
          session[:return_to] = request.request_uri
        end
      end

      def store_referer
        session[:refer_to] = request.env["HTTP_REFERER"]
      end

      # Redirect to the URI stored by the most recent store_location call or
      # to the passed default.
      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end

      def redirect_to_referer_or_default(default)
        redirect_to(session[:refer_to] || default)
        session[:refer_to] = nil
      end

      # Called from #current_user.  Now, attempt to login by basic authentication information.
      # def login_from_basic_auth
      #   authenticate_with_http_basic do |username, password|
      #     self.current_user = User.authenticate(username, password)
      #   end
      # end

    end
  end
end