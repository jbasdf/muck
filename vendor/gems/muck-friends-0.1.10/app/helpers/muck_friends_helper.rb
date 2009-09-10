module MuckFriendsHelper

  def all_friends(user)
    render :partial => 'friends/all_friends', :locals => { :user => user }
  end
  
  # Renders a partial that contains the friends of the given user
  # Parameters:
  # user1:              User whose friends are to be shown
  # user2:              User whose friends are to be checked to see if they are in common with user1
  # limit:              Number of records to show
  # partial:            The partial to render.  Default is 'friend_simple' which renders an icon and name for each friend.
  #                     Options include 'friend_icon' which only renders an icon or a custom partial.  Place custom partials
  #                     in app/views/friends
  # no_friends_content: Content to render if no users are found.  Pass ' ' to render nothing
  def mutual_friends(user1, user2, limit = 6, no_friends_content = nil, partial = 'friend_simple')
    return '' if user1.blank? || user2.blank?
    users = user1.friends & user2.friends
    users = users.first(limit)
    no_friends_content ||= t('muck.friends.no_mutual_friends')
    render_friends(users, partial, no_friends_content)
  end
  
  # Renders a partial that contains the friends of the given user
  # Parameters:
  # user:               User whose friends are to be shown
  # limit:              Number of records to show
  # partial:            The partial to render.  Default is 'friend_simple' which renders an icon and name for each friend.
  #                     Options include 'friend_icon' which only renders an icon or a custom partial.  Place custom partials
  #                     in app/views/friends
  # no_friends_content: Content to render if no users are found.  Pass ' ' to render nothing
  def friends(user, limit = 6, no_friends_content = nil, partial = 'friend_simple')
    return '' if user.blank?
    users = user.friends.find(:all, :limit => limit, :order => 'friends.created_at DESC')
    no_friends_content ||= t('muck.friends.no_friends')
    render_friends(users, partial, no_friends_content)
  end
  
  # Renders a partial that contains the friends of the given user
  # Parameters:
  # user:               User whose friends are to be shown
  # limit:              Number of records to show
  # partial:            The partial to render.  Default is 'friend_simple' which renders an icon and name for each friend.
  #                     Options include 'friend_icon' which only renders an icon or a custom partial.  Place custom partials
  #                     in app/views/friends
  # no_friends_content: Content to render if no users are found.  Pass ' ' to render nothing
  def followers(user, limit = 6, no_friends_content = nil, partial = 'friend_simple')
    return '' if user.blank?
    users = user.followers.find(:all, :limit => limit, :order => 'friends.created_at DESC')
    no_friends_content ||= t('muck.friends.no_followers')
    render_friends(users, partial, no_friends_content)
  end
  
  # Renders a partial that contains the friends of the given user
  # Parameters:
  # user:               User whose friends are to be shown
  # limit:              Number of records to show
  # partial:            The partial to render.  Default is 'friend_simple' which renders an icon and name for each friend.
  #                     Options include 'friend_icon' which only renders an icon or a custom partial.  Place custom partials
  #                     in app/views/friends
  # no_friends_content: Content to render if no users are found.  Pass ' ' to render nothing
  def followings(user, limit = 6, no_friends_content = nil, partial = 'friend_simple')
    return '' if user.nil?
    users = user.followings.find(:all, :limit => limit, :order => 'friends.created_at DESC')
    no_friends_content ||= t('muck.friends.not_following_anyone')
    render_friends(users, partial, no_friends_content)
  end

  # Render a list of all friend requests (if !GlobalConfig.enable_following)
  def friend_requests(user)
    if !GlobalConfig.enable_following 
      followers = user.followers
      render :partial => 'friends/friend_requests', :locals =>  { :followers => followers } unless followers.blank?
    end
  end
  
  def block_user_link(user, target)
    friend = user.friendship_with(target)
    return '' if friend.blank?
    dom_id = make_block_id(user, target)
    if friend.blocked?
      return wrap_friend_link(link_to_remote( I18n.t('muck.friends.unblock', :user => target.display_name), :url => user_friend_path(user, friend, :target_id => target, :unblock => true), :method => :put), dom_id, 'friendship-block')
    else
      return wrap_friend_link(link_to_remote( I18n.t('muck.friends.block', :user => target.display_name), :url => user_friend_path(user, friend, :target_id => target, :block => true), :method => :put), dom_id, 'friendship-block')
    end
  end
  
  # Render a follow/unfollow/friend request link appropriate to the current application settings and user relationship
  # Requires enable_following and enable_friending be set in global_config.yml
  #   If enable_following is true and enable_friending is false then only follow/unfollow links will be shown
  #   If enable_following is false and enable_friending is true then only friend request and unfriend links will be shown
  #   If enable_following is true and enable_friending is true then a hybrid model will be used.  Users can follow
  #   each other without permission but a mutual follow will result in a friendship.  Defriending a user will result in the
  #   other user becoming a follower
  def friend_link(user, target)
    
    # User not logged in
    if user.blank?
      if GlobalConfig.enable_following
        key = 'login_or_sign_up_to_follow'
      elsif GlobalConfig.enable_friending
        key = 'login_or_sign_up_to_friend'
      else
        return ''
      end
      return wrap_friend_link(I18n.t("muck.friends.#{key}", :login => link_to(t('muck.friends.login'), login_path), :signup => link_to(t('muck.friends.signup'), signup_path)))
    end
    
    return '' if target.blank?
    return '' if user == target
    
    dom_id = make_id(user, target)
        
    if GlobalConfig.enable_friending
      if user.friend_of?(target)
        return wrap_friend_link(link_to_remote( I18n.t('muck.friends.stop_being_friends_with', :user => target.display_name), :url => user_friend_path(user, target), :method => :delete), dom_id)
      elsif user.following?(target)
        return wrap_friend_link( I18n.t('muck.friends.friend_request_pending', :link => link_to_remote(I18n.t('muck.friends.delete'), :url => user_friend_path(user, target), :method => :delete)), dom_id)
      end
    elsif GlobalConfig.enable_following
      if user.following?(target)
        return wrap_friend_link(link_to_remote( I18n.t('muck.friends.stop_following', :user => target.display_name), :url => user_friend_path(user, target), :method => :delete), dom_id)
      end
    end
    
    if GlobalConfig.enable_friending && user.followed_by?(target)
      return wrap_friend_link(link_to_remote( I18n.t('muck.friends.acccept_friend_request', :user => target.display_name), :url => user_friends_path(user, :id => target), :method => :post), dom_id)
    end
    
    if GlobalConfig.enable_following
      wrap_friend_link(link_to_remote( I18n.t('muck.friends.start_following', :user => target.display_name), :url => user_friends_path(user, :id => target), :method => :post), dom_id)
    elsif GlobalConfig.enable_friending
      wrap_friend_link(link_to_remote( I18n.t('muck.friends.friend_request_prompt', :user => target.display_name), :url => user_friends_path(user, :id => target), :method => :post), dom_id)
    end
    
  end

  def accept_follower_link(user, target)
    dom_id = make_id(user, target)
    wrap_friend_link(link_to_remote( I18n.t('muck.friends.accept'), { :url => user_friends_path(user, :id => target), :method => :post}, {:id => "accept-#{target.id}", :class => 'notification-link'}), dom_id)
  end

  def ignore_friend_request_link(user, target)
    dom_id = make_id(user, target)
    wrap_friend_link(link_to_remote( I18n.t('muck.friends.ignore'), { :url => user_friend_path(user, target), :method => :delete }, {:id => "ignore-#{target.id}", :class => 'notification-link'}), dom_id)
  end

  protected
  
  # Handles render friend partials
  def render_friends(users, partial, no_friends_content)
    if users.length > 0
      render :partial => "friends/#{partial}", :collection => users
    else
      if no_friends_content.length > 0 # Do this so that a user can pass ' ' to get a blank string output
        no_friends_content
      else
        "<p class=\"no_friends_found\">#{no_friends_content}</p>"
      end
    end
  end
  
  def wrap_friend_link(link, dom_id = '', css = 'friendship-description')
    content_tag(:span, link, :id => dom_id, :class => css)
  end

  def make_id(user, target)
    user.dom_id(target.dom_id + '_friendship_')
  end
  
  def make_block_id(user, target)
    user.dom_id(target.dom_id + '_block_')
  end
  
end