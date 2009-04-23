class ApplicationController < ActionController::Base
  
  layout 'default'
    
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
   
  before_filter :set_body_class
  
  protected

  def setup_paging
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = (params[:per_page] || (Rails.env=='test' ? 1 : 40)).to_i
  end

  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end

  
  # uncomment this method if you would like to add directories to cms lite
  #def setup_cms_lite
    # this will be called by the cms lite plugin
    # prepend_cms_lite_path(File.join(RAILS_ROOT, 'content', 'help'))
  #end
  private
  def set_body_class
    @body_class ||= "body"
  end 

end
