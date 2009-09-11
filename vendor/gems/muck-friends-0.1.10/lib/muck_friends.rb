module MuckFriends
  # Statuses Array
  BLOCKED = 2
  FRIENDING = 1
  FOLLOWING = 0
end

ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckFriend }
ActiveRecord::Base.class_eval { include ActiveRecord::Acts::MuckFriendUser }
ActionController::Base.send :helper, MuckFriendsHelper

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]
