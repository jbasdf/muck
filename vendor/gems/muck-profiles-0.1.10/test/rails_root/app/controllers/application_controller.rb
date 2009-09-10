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
  
end
