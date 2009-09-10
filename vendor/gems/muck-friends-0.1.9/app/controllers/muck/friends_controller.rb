class Muck::FriendsController < ApplicationController
  unloadable

  before_filter :login_required, :except => [:index]
  before_filter :get_user_and_target, :except => [:index]
  
  def index
    @user = User.find(params[:user_id]) rescue current_user
    respond_to do |format|
      format.html { render :template => 'friends/index' }
    end
  end
  
  def create
    success = Friend.make_friends(@user, @target)

    if GlobalConfig.enable_following
      if success
        message = t('muck.friends.you_are_now_following', :user => @target.display_name)
      else
        message = t('muck.friends.problem_adding_follow', :user => @target.display_name)
      end
    elsif GlobalConfig.enable_friending
      if success
        message = t('muck.friends.friend_request_sent')
      else
        message = t('muck.friends.problem_sending_friend_request', :user  => @target.display_name)
      end
    end

    respond_to do |format|
      format.html { render_after_create_html(success, message) }
      format.js { render_after_create_js(success, message) }
      format.pjs { render_after_create_js(success, message) }
      format.json { render :json => { :success => success, :message => message, :friend_user => @target } }
    end

  end
  
  def update
    if params[:block]
      success = @user.block_user(@target)
    elsif params[:unblock]
      success = @user.unblock_user(@target)
    end
    
    if success
      if params[:block] == true
        message = t('muck.friends.blocked', :user => @target.display_name)
      elsif params[:block] == false
        message = t('muck.friends.unblocked', :user => @target.display_name)
      end
    else
      message = t('muck.friends.block_problem', :user => @target.display_name)
    end
    
    respond_to do |format|
      format.html { render_after_update_html(success, message) }
      format.js { render_after_update_js(success, message) }
      format.pjs { render_after_update_js(success, message) }
      format.json { render :json => { :success => success, :message => message, :friend_user => @target } }
    end
    
  end
  
  def destroy

    success = true
    # Other user may or may not be a friend.  If they weren't then revert_to_follower will return false.
    # We don't care that the other user wasn't reverted to a follower (since they might not have been a friend) so return true
    @user.drop_friend(@target)
    if GlobalConfig.enable_friending 
      message = t('muck.friends.removed_friendship', :user => @target.display_name)
    elsif GlobalConfig.enable_following
      message = t('muck.friends.stopped_following', :user => @target.display_name)
    end

    # if GlobalConfig.enable_friending 
    #   message = t('muck.friends.removed_friendship_error', :user => @target.display_name)
    # elsif GlobalConfig.enable_following
    #   message = t('muck.friends.removed_following_error', :user => @target.display_name)
    # end
    
    respond_to do |format|
      format.html { render_after_destroy_html(success, message) }
      format.js { render_after_destroy_js(success, message) }
      format.pjs { render_after_destroy_js(success, message) }
      format.json { render :json => { :success => success, :message => message } }
    end
  end
  
  protected
  
  def render_after_create_html(success, message)
    flash[:notice] = message
    redirect_to profile_path(@target)
  end

  def render_after_create_js(success, message)
    if success
      render(:update){|page| page.replace make_id(@user, @target), friend_link(@user, @target)}
    else
      render(:update){|page| page.alert message}
    end
  end
  
  def render_after_update_html(success, message)
    flash[:notice] = message
    redirect_to profile_path(@target)
  end

  def render_after_update_js(success, message)
    if success
      render(:update){|page| page.replace make_block_id(@user, @target), block_user_link(@user, @target)}
    else
      render(:update){|page| page.alert message}
    end
  end
    
  def render_after_destroy_html(success, message)
    flash[:notice] = message
    redirect_to profile_path(@target)
  end
  
  def render_after_destroy_js(success, message)
    if success
      render(:update){|page| page.replace make_id(@user, @target), friend_link(@user, @target)}
    else
      render(:update){|page| page.alert message}
    end
  end

  def make_id(user, target)
    user.dom_id(target.dom_id + '_friendship_')
  end
  
  def get_user_and_target
    if admin? && params[:user_id]
      @user = User.find(params[:user_id]) rescue current_user
    else
      @user = current_user
    end
    @target = User.find(params[:target_id] || params[:id])
  end
  
end
