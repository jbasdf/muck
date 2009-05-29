class Recommender::EntriesController < ApplicationController

  def initialize
    @no_index = true
  end
  
  def index
    @tags = Entry.tag_counts_on('tags', :order => 'count desc', :limit => 200)
    respond_to do |format|
      format.html { render :template => 'entries/index' }
    end
  end
  
  def tags tags
    @documents = Entry.tagged_with(tags, :on => 'tags')
  end

  # GET /documents
  # GET /documents.xml
  def index2
    @limit = params[:limit] ? params[:limit].to_i : 10
    @limit = 25 if @limit > 25
    @offset = params[:offset] ? params[:offset].to_i : 0
    @documents = Entry.find(:all, :limit => @limit, :offset => @offset)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  def frames
    render(:template => 'documents/frames.html', :layout => false)
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @languages = Language.find(:all, :order => "name")
    @page_title = "Related Resources"
    @document = Entry.find(params[:id], :include => :feed)
    if @document.nil?
      render_text "Unable to find the specified document"
      return
    end
    @document_title = @document.title + " (" + @document.feed.short_title + ")"
    I18n.locale = @document.language[0..1]
    @limit = params[:limit] ? params[:limit].to_i : 20
    @limit = 40 if @limit > 40

    respond_to do |format|
      format.html { 
      if params[:details] == 'true'
        render :template => "documents/details", :layout => "default"
      else
        render :template => "documents/show", :layout => "default"
      end
      }# show.html.erb
      format.xml  { render :xml => @document }
    end
  end
  
  def track_clicks
    user_agent = request.env['HTTP_USER_AGENT']
    redirect_to Entry.track_click(session, params[:id], request.env['HTTP_REFERER'], params[:target], request.env['HTTP_X_FORWARDED_FOR'], user_agent) if !/Googlebot/.match(user_agent) 
  end
  
  def collections
    @feeds = Feed.find(:all, :order => "harvested_from_title, title")
    @languages = Language.find(:all, :order => "name")
    render :template => "documents/collections", :layout => "default"
  end

end
