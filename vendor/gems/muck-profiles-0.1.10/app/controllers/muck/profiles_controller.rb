class Muck::ProfilesController < ApplicationController
  unloadable

  def index
    respond_to do |format|
      format.html { render :template => 'profiles/index' }
    end
  end

  # show a given user's public profile information
  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @page_title = @user.display_name
    respond_to do |format|
      format.html { render :template => 'profiles/show' }
    end
  end

  def edit
    @page_title = t('muck.profiles.edit_profile')
    @user = User.find(params[:user_id])
    @profile = @user.profile
    respond_to do |format|
      format.pjs do
        render_as_html do
          render :template => 'profiles/edit', :layout => false # fancybox request
        end
      end
      format.html { render :template => 'profiles/edit' }
    end
  end
  
  def update
    @page_title = t('muck.profiles.edit_profile')
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @profile.update_attributes!(params[:profile])
    respond_to do |format|
      flash[:notice] = t('muck.profiles.edit_success')
      format.html { redirect_back_or_default edit_user_profile_path(@user) }
    end
  rescue ActiveRecord::RecordInvalid => ex
    flash[:error] = t('muck.profiles.edit_failure')
    render :action => :edit
  end

end
