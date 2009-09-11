class Muck::IdentityFeedsController < ApplicationController
  
  unloadable
  
  before_filter :get_owner, :only => [:index, :new, :create]
  before_filter :has_permission?, :only => [:index, :new, :create]
  
  before_filter :get_identity_feed, :only => [:destroy, :update]
  before_filter :has_identity_feed_permission?, :only => [:destroy, :update]
  
  def index
    @service_categories = ServiceCategory.sorted.find(:all, :include => [:identity_services])
    @user_services = @parent.identity_feeds.find(:all, :include => [{:feed => :service}])
    respond_to do |format|
      format.html { render :template => 'identity_feeds/index' }
    end
  end
  
  def new
    @service = Service.find(params[:service_id])
    @feed = Feed.new
    respond_to do |format|
      format.html { render :template => 'identity_feeds/new' }
      format.pjs { render :text => get_new_html(@service, @parent, @feed) }
    end
  end
  
  def create
    @service = Service.find(params[:service_id])
    @feed = Feed.new(:uri => params[:uri], :login => params[:username])
    feeds = Feed.create_service_feeds(@service, params[:uri], params[:username], params[:password], current_user.id)
    if feeds.blank?
      success = false
      if params[:username]
        message = I18n.t('muck.raker.no_feeds_from_username')
      else
        message = I18n.t('muck.raker.no_feeds_at_uri')
      end
    else
      success, messages = add_feeds_to_parent(@parent, feeds)
      message = messages.join('<br />')
    end
    respond_to do |format|
      format.html do
        flash[:notice] = message if message
        redirect_to polymorphic_url([@parent, :identity_feeds]) 
      end
      format.pjs do
        flash[:notice] = message if message
        render :template => 'identity_feeds/new', :layout => false
      end
      format.json do
        render :json => {:parent => @parent, :service => @service, :feeds => feeds, :success => success, :message => message }.as_json
      end
    end
  end
  
  def edit
    @identity_feed = IdentityFeed.find(params[:id])
    respond_to do |format|
      format.html { render :template => 'identity_feeds/edit' }
      format.pjs { render :text => get_edit_html(@identity_feed) }
    end
  end
  
  def update
  end
  
  def destroy
    feed = @identity_feed.feed
    @identity_feed.destroy
    feed.delete_if_unused(current_user) # Delete the feed if there are no references to it
    respond_to do |format|
      format.html do
        flash[:notice] = t("muck.raker.identity_feed_removed")
        redirect_to polymorphic_url([@identity_feed.ownable, :identity_feeds]) 
      end
      format.js do
        render(:update) do |page|
          page << "jQuery('##{@identity_feed.dom_id}').fadeOut();"
        end
      end
      format.json do
        render :json => { :success => true,
                          :identity_feed => @identity_feed,
                          :message => t("muck.raker.identity_feed_removed") }
      end
    end
  end
  
  protected
    
    def get_owner
      setup_parent('service')
    end
    
    def get_identity_feed
      @identity_feed = IdentityFeed.find(params[:id])
    end
    
    def has_identity_feed_permission?
      if !@identity_feed.can_edit?(current_user)
        message = I18n.t('muck.raker.cant_modify_identity_feed')
        respond_to do |format|
          format.html do
            flash[:notice] = message
            redirect_back_or_default current_user
          end
          format.js { render(:update){|page| page.alert message}}
        end
      end
    end
    
    def has_permission?
      @parent.can_edit?(current_user)
    end
    
    def get_new_html(service, parent, feed)
      render_as_html do
        render_to_string(:partial=> 'identity_feeds/form', :locals => { :service => service, :parent => parent, :feed => feed })
      end
    end
    
    def get_edit_html(identity_feed)
      render_as_html do
        render_to_string(:partial=> 'identity_feeds/form', :locals => { :service => identity_feed.feed.service, :parent => identity_feed.ownable, :feed => identity_feed.feed })
      end
    end
    
    def add_feeds_to_parent(parent, feeds)
      messages = []
      success = false
      feeds.each do |feed|
        begin
          parent.own_feeds << feed
          success = true
          if params[:username]
            messages << I18n.t('muck.raker.successfully_added_username_feed', :service => feed.title || @service.name)
          else
            messages << I18n.t('muck.raker.successfully_added_uri_feed', :service => @service.name, :uri => feed.title || params[:uri])
          end
        rescue ActiveRecord::RecordInvalid => ex
          if ex.to_s == 'Validation failed: Feed has already been taken'
            if params[:username]
              messages << I18n.t('muck.raker.already_added_username_feed', :service => feed.title || @service.name, :username => params[:username])
            else
              messages << I18n.t('muck.raker.already_added_uri_feed', :service => @service.name, :uri => feed.title || params[:uri])
            end
          end
        end
      end
      [success, messages]
    end
end