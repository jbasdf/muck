# new file app/controllers/activations_controller.rb
class Muck::ActivationsController < ApplicationController
  unloadable
  
  ssl_required :new
  before_filter :not_logged_in_required, :only => [:new]
  
  def new
    @user = User.find_using_perishable_token(params[:id])
    if @user.blank?
      flash[:notice] = t('muck.users.activation_not_found')
      redirect_to new_user_path and return
    end
    
    if @user.active?
      flash[:notice] = t('muck.users.already_activated')
      redirect_to login_path and return
    end
    
    if @user.activate!
      UserSession.create(@user)
      flash[:notice] = t('muck.users.account_activated')
      @user.deliver_activation_confirmation!
      redirect_to welcome_user_path(@user)
    else
      render :action => :new
    end
    
  end

end