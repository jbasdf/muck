class Admin::Recommender::FeedsController < ApplicationController

  layout "default"

  before_filter :login_required, :only => [:index, :edit, :ban, :unban, :destroy, :update, :new]

  # GET /feeds
  # GET /feeds.xml
  def index
    @feeds = Feed.find(:all, :conditions => "status >= 0", :order => "title")
    @banned_feeds = Feed.find(:all, :conditions => "status < 0", :order => "title")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @feeds.to_xml }
    end
  end

  def entries
    @new_feed = params[:new_feed]
    @feed = Feed.find(params[:id])
    @courses = @feed.entries.find(:all, :order => "title")

    respond_to do |format|
      format.html { render :partial => "courses", :layout => "default" }
      format.xml  { render :xml => @courses.to_xml }
    end
  end

  # GET /feeds/selection_list
  def selection_list
    @feeds = Feed.find(:all, :order => "short_title")
    render :partial => "feed_selection", :collection => @feeds, :layout => false
  end

  # GET /feeds/1
  # GET /feeds/1.xml
  def show
    redirect_to "/feeds/" + params[:id] + "/entries" 
  end

  # GET /feeds/new
  def new
    @no_follow = true
    @feeds = Feed.find(:all, :conditions => "status >= 0", :order => "title")
    @feed = Feed.new
    render :layout => "default"
  end

  # GET /feeds/1;edit
  def edit
    @feed = Feed.find(params[:id])
    render :layout => "default"
  end

#  # GET /feeds/1;reharvest
#  def harvest_now
#    @no_index = true
#    @feed = Feed.find(params[:id])
#    @feed.entries.destroy_all
#    @feed.failed_requests = "0"
#    @feed.refreshed_at = "2001"
#    @feed.save!
#  end

  # GET /feeds/1;ban
  def ban
    @feed = Feed.find(params[:id])
    @feed.entries.destroy_all
    @feed.status = -1
    @feed.save!
    #redirect_to feeds_path
    redirect_to "/feeds"
  end

  # GET /feeds/1;unban
  def unban
    @feed = Feed.find(params[:id])
    @feed.unban = true
    @feed.status = 0
    @feed.refreshed_at = "2001"
    @feed.save!
    #redirect_to feeds_path
    redirect_to "/feeds"
  end

#  def notification_feed_added(feed)
#    begin
#        FeedNotify.deliver_feed_added(feed)
#        return
#    rescue Exception => e
#        # unble to send activation email.  Activate the user anyway which means
#        # letting flow continue below
#        logger.error 'Unable to send feed added notification E-Mail:'
#        logger.error e
#    end
#  end
#
#  def notification_feed_updated(feed)
#    begin
#        FeedNotify.deliver_feed_updated(feed)
#        return
#    rescue Exception => e
#        # unble to send activation email.  Activate the user anyway which means
#        # letting flow continue below
#        logger.error 'Unable to send feed added notification E-Mail:'
#        logger.error e
#    end
#  end

  # POST /feeds
  # POST /feeds.xml
  def create
    @feed = Feed.new(params[:feed])
    @feed.harvested_from_display_uri = @feed.display_uri
    @feed.entries_count = 0
    @feed.last_requested_at = Time.now - 2592000 
    @feed.last_harvested_at = Time.now - 2592000

    respond_to do |format|
      if @feed.save
        flash[:notice] = 'Feed was successfully created.'

        # email the admin to let them know a feed has been added
#        notification_feed_added(@feed)

        # redirect to a page letting them know the feed has been created
        #format.html { redirect_to entries_path(@feed) + "?new_feed=true" }
        format.html { redirect_to "/feeds/" }
        format.xml  { head :created, :location => feed_url(@feed) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed.errors.to_xml }
      end
    end
  end

  # PUT /feeds/1
  # PUT /feeds/1.xml
  def update
    @feed = Feed.find(params[:id])

    # force a harvest now
#    harvest_now

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
#        notification_feed_updated(@feed)
        flash[:notice] = 'Feed was successfully updated.'
        format.html { 
        redirect_to "/feeds/"
        return
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed.errors.to_xml }
      end
    end
  end

#  # DELETE /feeds/1
#  # DELETE /feeds/1.xml
#  def destroy
#    @feed = Feed.find(params[:id])
#    @feed.destroy
#
#    respond_to do |format|
#      format.html { redirect_to feeds_url }
#      format.xml  { head :ok }
#    end
#  end

end
