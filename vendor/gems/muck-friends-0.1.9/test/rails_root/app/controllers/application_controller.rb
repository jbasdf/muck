class ApplicationController < ActionController::Base
  include SslRequirement
  helper :all
  protect_from_forgery

  protected
    # called by Admin::Muck::BaseController to check whether or not the
    # user should have access to the admin UI
    def admin_access?
      admin?
    end
  
    # only require ssl if we are in production
    def ssl_required?
      return ENV['SSL'] == 'on' ? true : false if defined? ENV['SSL']
      return false if local_request?
      return false if RAILS_ENV == 'test'
      ((self.class.read_inheritable_attribute(:ssl_required_actions) || []).include?(action_name.to_sym)) && (RAILS_ENV == 'production' || RAILS_ENV == 'staging')
    end
  
end
