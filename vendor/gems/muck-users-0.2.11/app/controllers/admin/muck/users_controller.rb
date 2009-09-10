class Admin::Muck::UsersController < Admin::Muck::BaseController
  unloadable
    
  before_filter :get_user, :only => [:update, :destroy]
  
  def index
    @user_count = User.count
    @user_inactive_count = User.inactive_count
    @users = User.by_newest.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'admin/users/index' }
    end
  end

  def inactive
    @user_inactive_count = User.inactive_count
    @users = User.inactive.paginate(:page => @page, :per_page => @per_page)
    respond_to do |format|
      format.html { render :template => 'admin/users/inactive' }
    end
  end
  
  def inactive_emails
    @user_inactive_count = User.inactive_count
    @users = User.inactive
    respond_to do |format|
      format.html { render :template => 'admin/users/inactive_emails' }
    end
  end
  
  def activate_all
    User.activate_all
    respond_to do |format|
      format.html do
        redirect_to inactive_admin_users_path
      end
    end
  end

  def search_results
    @users = User.do_search( params[:query] ).paginate(:page => @page, :per_page => @per_page )
  end

  def search
    search_results
    respond_to do |format|
      format.html do
        render :template => 'admin/users/index'
      end
    end
  end

  def ajax_search
    search_results
    respond_to do |format|
      format.html do
        render :partial => 'admin/users/table', :layout => false
      end
    end
  end

  def update
    if is_me?(@user)
      message = I18n.t("muck.users.cannot_deactivate_yourself")
    else
      if @user.force_activate!
        message = I18n.t('muck.users.user_marked_active')
      else
        message = I18n.t('muck.users.user_marked_inactive')
      end
    end    
    activate_text = '<div class="flasherror">' + message + '</div>'
    activate_text << render_to_string(:partial => 'admin/users/activate', :locals => {:user => @user})
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html @user.dom_id('link'), activate_text
        end
      end
    end
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      self.current_user = @user
      flash[:notice] = t("muck.users.user_enabled")
    else
      flash[:error] = t("muck.users.user_enable_problem")
    end
    redirect_to :action => 'index'
  end
  
  def disable
    @user = admin? ? User.find(params[:id]) : User.find(current_user)
    if @user.update_attribute(:enabled, false)
      flash[:notice] = t("users.user_disabled")
    else
      flash[:error] = t("users.user_disable_problem")
    end
    redirect_to :action => 'index'
  end
  
  def destroy
    @user.destroy
    respond_to do |format|
      format.html do
        flash[:notice] = I18n.t('muck.users.user_successfully_deleted', :login => @user.login)
        redirect_to admin_users_path
      end
      format.xml  { head :ok }
      format.js { render(:update){|page| page.visual_effect :fade, "#{@user.dom_id('row')}".to_sym} }
    end
  end
  
  private 
  
  def get_user
    @user = User.find(params[:id])
  end
  
end
