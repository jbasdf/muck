class Muck::PasswordResetsController < ApplicationController
  unloadable
  
  ssl_required :edit, :update
  ssl_allowed :new, :create
  before_filter :not_logged_in_required
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  # Enter email address to recover password 
  def new
    @title = t('muck.users.recover_password')
    respond_to do |format|
      format.html { render :template => 'password_resets/new' }
    end
  end

  # Forgot password action
  def create
    @title = t('muck.users.recover_password')
    if @user = User.find_by_email(params[:reset_password][:email])
      @user.deliver_password_reset_instructions!
      flash[:notice] = t('muck.users.password_reset_link_sent')
      respond_to do |format|
        format.html { redirect_to login_path }
      end
    else
      flash[:notice] = t('muck.users.could_not_find_user_with_email')
      respond_to do |format|
        format.html { render :template => 'password_resets/new' }
      end
    end  
  end

  # Action triggered by clicking on the /reset_password/:id link recieved via email
  # Makes sure the id code is included
  # Checks that the id code matches a user in the database
  # Then if everything checks out, shows the password reset fields
  def edit
    @title = t('muck.users.reset_password')
    respond_to do |format|
      format.html { render :template => 'password_resets/edit' }
    end
  end

  # Reset password action /reset_password/:id
  # Checks once again that an id is included and makes sure that the password field isn't blank
  def update
    if @user.reset_password!(params[:user])
      flash[:success] = t('muck.users.password_updated')
      respond_to do |format|
        format.html { redirect_to account_url }
      end
    else
      respond_to do |format|
        format.html { render :template => 'password_resets/edit' }
      end
    end
  end

  private
  
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = t('muck.users.sorry_invalid_reset_code')
      respond_to do |format|
        format.html { redirect_to root_url }
      end      
    end
  end
  
  def permission_denied
    respond_to do |format|
      format.html do
        flash[:notice] = t('muck.users.already_logged_in')
        redirect_to account_url
      end
    end
  end

end
