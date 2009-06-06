class Recommender::EntriesController < ApplicationController

  def initialize
    @no_index = true
  end
  
  def index
    @tags = Tag.find(:all, :select => 'name, frequency AS count', :conditions => 'root = true', :order => 'frequency desc', :limit => 200)
    respond_to do |format|
      format.html { render :template => 'entries/index' }
    end
  end
  
  def browse_by_tags tags
    @entries = Entry.tagged_with(tags, :on => 'tags')
  end

  def show
    @languages = Language.find(:all, :order => "name")
    @page_title = "Related Resources"
    @entry = Entry.find(params[:id], :include => :feed)
    if @entry.nil?
      render_text "Unable to find the specified document"
      return
    end
    @entry_title = @entry.title + " (" + @entry.feed.short_title + ")"
    I18n.locale = @entry.language[0..1]
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
      format.xml  { render :xml => @entry }
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
