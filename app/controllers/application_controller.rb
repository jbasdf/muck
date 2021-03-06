class ApplicationController < ActionController::Base
  
  include SslRequirement
  
  layout :choose_layout
    
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  acts_as_muck_content_handler
  
  before_filter :set_locale
  before_filter :setup_paging
  before_filter :set_will_paginate_string

  protected

    def set_locale
      discover_locale
    end

    # **********************************************
    # SSL method
    # only require ssl if we are in production
    def ssl_required?
      return false unless GlobalConfig.enable_ssl
      return ENV['SSL'] == 'on' ? true : false if defined? ENV['SSL']
      return false if local_request?
      return false if RAILS_ENV == 'test'
      ((self.class.read_inheritable_attribute(:ssl_required_actions) || []).include?(action_name.to_sym)) && (RAILS_ENV == 'production' || RAILS_ENV == 'staging')
    end
    
    # Automatically respond with 404 for ActiveRecord::RecordNotFound
    def record_not_found
      render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
    end
  
    # called by Admin::Muck::BaseController to check whether or not the
    # user should have access to the admin UI
    def admin_access_required
      access_denied unless admin?
    end

  private

    def choose_layout
      if params[:controller].index('admin') == 0
        'admin'
      else
        'default'
      end
    end

end
