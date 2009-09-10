class Muck::FeedPreviewsController < ApplicationController

  unloadable

  def new
    respond_to do |format|
      format.pjs do
        render_as_html do
          render :template => 'feed_previews/new', :layout => false
        end
      end
      format.html { render :template => 'feed_previews/new' }
    end
  end

  def select_feeds
    @feed = Feed.new(params[:feed])
    @feeds = Feed.gather_information(@feed.uri)
    respond_to do |format|
      format.pjs do
        render_as_html do
          render :template => 'feed_previews/select_feeds', :layout => false
        end
      end
      format.html { render :template => 'feed_previews/select_feeds' }
    end
  end
  
  def create
    
  end

end