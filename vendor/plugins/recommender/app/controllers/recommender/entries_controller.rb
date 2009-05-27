class Recommender::RecommendationsController < ApplicationController
  # GET /recommendations
  # GET /recommendations.xml
  def index
    @details = params[:details] == "true"

    @referrer = request.env['HTTP_REFERER']
    @uri = params[:u] || @referrer
    
    if params[:educommons]
      @uri = @uri[%r=http://.*?/.*?/[^/]+=] || @uri
      params[:title] = true
      params[:more_link] = true
    end

    Entry.track_time_on_page(session, @uri)
    @document = Entry.recommender_entry(@uri)
    I18n.locale = @document.language[0..1] if !@document.nil?

    @limit = params[:limit] ? params[:limit].to_i : 5
    @limit = 25 if @limit > 25
    
    respond_to do |format|
      format.html {
        @languages = Language.find(:all, :order => "name")
        order = params[:order] || "mixed"
        redirect_to "/documents/" + @document.id.to_s + "?limit=" + @limit.to_s + "&order=" + order + "&details=" + @details.to_s if !@document.nil?
        render(:template => '/recommendations/document_not_found.html.erb', :layout => false) if @document.nil?
      } 
      format.xml  { 
        render(:template => '/recommendations/index.xml.builder', :layout => false) 
      }
      format.pjs {
        if @document.nil?
          render_text ""
        else
          @host = "http://" + URI.parse(@uri).host
          render(:template => 'recommendations/index.pjs.erb', :layout => false)  
        end
      }
      format.rss { render(:template => 'recommendations/index.rss.builder', :layout => false)  }
    end
  end

end
