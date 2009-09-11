class CmsLiteController < ApplicationController
  unloadable
  
  before_filter :login_required, :only => [:show_protected_page]

  def show_page
    render_content_page(CmsLite::PAGES_PATH)
  end
  
  def show_protected_page
    render_content_page(CmsLite::PROTECTED_PAGES_PATH)
  end
  
  def render_content_page(cms_lite_path, request_layout = '')
    content_page = nil
    CmsLite.content_paths.each do |content_path|
      content_page_key = params[:content_page].is_a?(Array) ? params[:content_page].join('/') : params[:content_page]
      path = File.join(RAILS_ROOT, content_path, cms_lite_path, I18n.locale.to_s, params[:content_key], content_page_key)
      format = params[:format] || 'htm'
      content_page = Dir.glob("#{path}.#{format}").first
      content_page = Dir.glob("#{path}").first  if content_page.nil?
      content_page = Dir.glob("#{path}.*").first  if content_page.nil?
      break if !content_page.nil?
    end    
    raise CmsLite::Exceptions::MissingTemplateError, "Could not find template for: '#{cms_lite_path}'" if content_page.nil?
    respond_to do |format|
      format.html { render :file => content_page, :layout =>  choose_layout(params[:content_key]) }
      format.js { render :file => content_page, :layout => false }
      format.xml { render :file => content_page, :layout => false }
    end
  rescue CmsLite::Exceptions::MissingTemplateError => ex
    render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
  end
  
  def choose_layout(content_key)
    layout = CmsLite.cms_layouts[content_key]
    layout = CmsLite.cms_layouts[:default] if layout.blank?
    layout ||= 'application'
  end
  
end