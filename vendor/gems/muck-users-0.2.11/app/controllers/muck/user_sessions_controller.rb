class Muck::UserSessionsController < ApplicationController
  unloadable
  
  ssl_required :new, :create
  before_filter :login_required, :only => :destroy
  before_filter :not_logged_in_required, :only => [:new, :create]
  
  def new
    @title = t('muck.users.sign_in_title')
    @user_session = UserSession.new
    respond_to do |format|
      format.html { render :template => 'user_sessions/new' }
    end
  end
  
  def create
    @title = t('muck.users.sign_in_title')
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('muck.users.login_success')
      respond_to do |format|
        format.html { redirect_back_or_default user_path(@user_session.user) }
      end
    else
      flash[:notice] = t('muck.users.login_fail')
      respond_to do |format|
        format.html { render :template => 'user_sessions/new' }
      end
    end
  end
  
  def destroy
    @title = t('muck.users.sign_out_title')
    current_user_session.destroy
    flash[:notice] = t('muck.users.login_out_success')
    respond_to do |format|
      format.html { redirect_to logout_complete_path }
    end
  end
end