class Admin::Muck::FeedsController < Admin::Muck::BaseController

  unloadable

  def index
    @feeds = Feed.by_newest.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'admin/feeds/index' }
      format.xml  { render :xml => @feeds.to_xml }
    end
  end

  def update
    feed = Feed.find(params[:id])
    if params[:status] == 'unban'
      unban(feed)
      flash[:notice] = t('muck.raker.feed_validated_message')
    elsif params[:status] == 'ban'
      ban(feed)
      flash[:notice] = t('muck.raker.feed_banned_message')
    end
    respond_to do |format|
      format.html { redirect_to admin_feeds_path }
    end
  end

  protected
  
    def ban(feed)
      feed.entries.destroy_all
      feed.status = -1
      feed.save!
    end

    def unban(feed)
      feed.status = 0
      feed.save!
    end
  
end
