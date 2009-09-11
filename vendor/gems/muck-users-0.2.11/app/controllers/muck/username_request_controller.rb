class Muck::UsernameRequestController < ApplicationController
  unloadable
  
  ssl_allowed :new, :create
  before_filter :not_logged_in_required

  # Enter email address to recover username 
  def new
    @title = t('muck.users.username_request')
    respond_to do |format|
      format.html { render :template => 'username_request/new' }
    end
  end

  # Forgot username action
  def create
    @title = t('muck.users.username_request')
    if @user = User.find_by_email(params[:request_username][:email])
      @user.deliver_username_request!
      flash[:notice] = t('muck.users.username_sent')
      respond_to do |format|
        format.html { redirect_to login_path }
      end
    else
      flash[:notice] = t('muck.users.could_not_find_user_with_email')
      respond_to do |format|
        format.html { render :template => 'username_request/new' }
      end
    end  
  end

end
