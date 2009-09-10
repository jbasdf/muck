class Muck::RecommendationsController < ApplicationController
  
  unloadable
    
  # GET /recommendations
  # GET /recommendations.xml
  def index
    @details = params[:details] == "true"

    @uri = params[:u] || request.env['HTTP_REFERER']
    if !allowed_uri(@uri)
      render :text => '<!-- permission denied -->'
      return
    end
    
    if params[:educommons]
      @uri = @uri[%r=http://.*?/.*?/[^/]+=] || @uri
      params[:title] = true
      params[:more_link] = true
    end

    Entry.track_time_on_page(session, @uri)
    @entry = Entry.recommender_entry(@uri)
#    I18n.locale = @entry.language[0..1] if !@entry.nil?

    @limit = params[:limit] ? params[:limit].to_i : 5
    @limit = 25 if @limit > 25
    
    respond_to do |format|
      format.html {
        order = params[:order] || "mixed"
        redirect_to resource_path(@entry) + "?limit=" + @limit.to_s + "&order=" + order + "&details=" + @details.to_s if !@entry.id.nil?
      } 
      format.xml  { 
        render(:template => @entry.id.nil? ? '/recommendations/index_real_time.xml.builder' : '/recommendations/index.xml.builder', :layout => false) 
      }
      format.pjs {
        @host = "http://" + URI.parse(@uri).host
        render(:template => @entry.id.nil? ? 'recommendations/index_real_time.pjs.erb' : 'recommendations/index.pjs.erb', :layout => false)
      }
      format.rss {
        render(:template => 'recommendations/index.rss.builder', :layout => false)  
      }
    end
  end
  
  protected
  
  def allowed_uri(uri)
    uri.match(/^(10\.|192\.168|172\.|127\.)/) == nil && uri.include?('localhost') == false
  end
  
end
