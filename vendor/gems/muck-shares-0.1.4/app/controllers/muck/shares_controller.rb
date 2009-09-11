class Muck::SharesController < ApplicationController
  unloadable
  
  before_filter :login_required, :except => [:index]
  before_filter :setup_user
  before_filter :get_share, :only => [:destroy]
  
  def index
    @shares = @user.shares.by_newest
    respond_to do |format|
      format.html { render :template => 'shares/index' }
      format.pjs { render :template => 'shares/index', :layout => false }
    end
  end
  
  def new
    @page_title = t('muck.shares.new_share')
    @share = Share.new(:uri => params[:uri] || params[:u], :title => params[:title] || params[:t], :message => params[:message] || params[:m])
    respond_to do |format|
      format.html { render :template => 'shares/new', :layout => 'popup' }
      format.pjs { render :template => 'shares/new', :layout => false }
    end
  end
  
  def create
    @share = current_user.shares.build(params[:share])
    @share.save!
    # TODO add UI that will let the user share with specific users
    share_to = nil
    attach_to = @share.discover_attach_to rescue nil # try to find an object to attach the activity to ie an entry
    @share.add_share_activity(share_to, attach_to)
    message = t('muck.shares.create_success')
    handle_after_create(true, message)
  rescue ActiveRecord::RecordInvalid => ex
    if @share
      errors = @share.errors.full_messages.to_sentence
    else
      errors = ex
    end
    message = t('muck.shares.create_error', :errors => errors)
    handle_after_create(false, message)
  end

  def destroy
    @share.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = t('muck.shares.share_removed')
        redirect_back_or_default(current_user)
      end
      format.js do
        render(:update) do |page|
          page << "jQuery('##{@share.dom_id}').fadeOut();"
        end
      end
      format.json { render :json => { :success => true, :message => t("muck.shares.share_removed"), :share_id => @share.id } }
    end
  end

  protected

  def handle_after_create(success, message = '')
    if success
      respond_to do |format|
        format.html { do_after_create_action(success, message) }
        format.json { render :json => { :success => true, :share => @share, :message => message, :html => get_share_html(@share) } }
      end
    else
      respond_to do |format|
        format.html { do_after_create_action(success, message) }
        format.json { render :json => { :success => false, :message => message, :errors => @errors } }
      end
    end
  end
  
  def do_after_create_action(success, message)
    flash[:error] = message if !success
    if "true" == params[:render_new]
      flash[:notice] = message if success
      render :template => 'shares/new'
    else
      redirect_back_or_default(user_shares_path(@user))
    end
  end
  
  def get_share
    @share = Share.find(params[:id])
    unless @share.can_edit?(current_user)
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t('muck.shares.cant_delete_share')
          redirect_back_or_default(user_shares_path(@user))
        end
        format.js { render(:update){|page| page.alert I18n.t('muck.shares.cant_delete_share')}}
      end
    end
  end

  def get_share_html(share)
    render_as_html do
      render_to_string(:partial => "shares/share", :object => share)
    end
  end
  
  def setup_user
    @user = User.find(params[:user_id]) rescue current_user
  end
end
