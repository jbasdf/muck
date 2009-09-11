class Muck::FeedsController < ApplicationController

  unloadable
  
  before_filter :get_parent
  
  def index
    @feeds = Feed.valid.by_title.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'feeds/index' }
      format.xml  { render :xml => @feeds.to_xml }
    end
  end

  # pass layout=popup to remove most of the chrome
  def show
    @feed = Feed.find(params[:id])
    @entries = @feed.entries
    respond_to do |format|
      format.html { render :template => 'feeds/show', :layout => params[:layout] || true  }
      format.pjs { render :template => 'feeds/show', :layout => false }
      format.json { render :json => @feed.as_json }
    end
  end

  def new
    respond_to do |format|
      format.html { render :template => 'feeds/new', :layout => 'popup' }
    end
  end

  def new_extended
    respond_to do |format|
      format.html { render :template => 'feeds/new_extended', :layout => 'popup' }
    end
  end

  def create
    @feed = Feed.new(params[:feed])
    @feed.contributor = current_user # record the user that submitted the feed for auditing purposes
    @feed.harvested_from_display_uri = @feed.display_uri
    
    # setup the feed to be harvested
    @feed.entries_count = 0
    @feed.last_requested_at = 4.weeks.ago
    @feed.last_harvested_at = 4.weeks.ago

    # associate the parent if present
    @parent.feeds << @feed if @parent
    
    after_create_response(@feed.save)
  end

  def edit
    @feed = Feed.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'feeds/edit', :layout => 'popup' }
    end
  end
  
  def update
    @feed = Feed.find(params[:id])
    after_update_response(@feed.update_attributes(params[:feed]))
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    after_destroy_response
  end
  
  protected

    def get_parent
      if !params[:parent_type] || !params[:parent_id]
        return
      end
      @klass = params[:parent_type].to_s.constantize
      @parent = @klass.find(params[:parent_id])
      unless has_permission_to_add_feed(current_user, @parent)
        permission_denied
      end
    end
  
    def has_permission_to_add_feed(user, parent)
      user == parent || parent.can_add_feed?(user)
    end
    
    # Handles render and redirect after success or failure of the
    # create action.  Override to perform a different action
    def after_create_response(success)
      if success
        flash[:notice] = t('muck.raker.feed_successfully_created')
        respond_to do |format|
          format.html { redirect_to feed_path(@feed) }
          format.pjs { render :template => 'feeds/show', :layout => false }
          format.json { render :json => @feed.as_json }
          format.xml  { head :created, :location => feed_url(@feed) }
        end
      else
        respond_to do |format|
          format.html { render :template => "feeds/new" }
          format.pjs { render :template => "feeds/new", :layout => false }
          format.json { render :json => @feed.as_json }
          format.xml  { render :xml => @feed.errors.to_xml }
        end
      end
    end
  
    # Handles render and redirect after success or failure of the
    # update action.  Override to perform a different action
    def after_update_response(success)
      respond_to do |format|
        if success
          flash[:notice] = t('muck.raker.feed_successfully_updated')
          format.html { redirect_to feed_path(@feed) }
          format.xml  { head :ok }
        else
          format.html { render :template => "feeds/edit" }
          format.xml  { render :xml => @feed.errors.to_xml }
        end
      end
    end
    
    # Handles render and redirect after the delete action.
    # Override to perform a different action
    def after_destroy_response
      respond_to do |format|
        format.html { redirect_to feeds_path }
        format.xml  { head :ok }
      end
    end
    
end
