module ActiveRecord
  module Acts #:nodoc:
    module MuckFriendUser #:nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_friend_user(options = {})

          has_many :friendships, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = #{MuckFriends::FRIENDING}", :dependent => :destroy
          has_many :follower_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{MuckFriends::FOLLOWING}", :dependent => :destroy
          has_many :following_friends, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => "status = #{MuckFriends::FOLLOWING}", :dependent => :destroy
          has_many :blocked_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{MuckFriends::BLOCKED}", :dependent => :destroy

          has_many :friends,   :through => :friendships, :source => :invited
          has_many :followers, :through => :follower_friends, :source => :inviter
          has_many :followings, :through => :following_friends, :source => :invited
          has_many :blocked_users, :through => :blocked_friends, :source => :inviter
          
          has_many :initiated_by_me, :class_name => "Friend", :foreign_key => "inviter_id"
          has_many :not_initiated_by_me, :class_name => "Friend", :foreign_key => "invited_id"

          has_many :friendships_initiated_by_me, :through => :initiated_by_me, :source => :invited
          has_many :friendships_not_initiated_by_me, :through => :not_initiated_by_me, :source => :inviter
                    
          has_many :occurances_as_friend, :class_name => "Friend", :foreign_key => "invited_id"

          include ActiveRecord::Acts::MuckFriendUser::InstanceMethods
          extend ActiveRecord::Acts::MuckFriendUser::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods

      end

      # All the methods available to a record that has had <tt>acts_as_muck_friend</tt> specified.
      module InstanceMethods
        
        # Feed to friends and followers
        def feed_to
          @feed_to_users ||= [self] | self.friends | self.followers # prevent duplicates in the array
        end
        
        # Indicates whether or not the give user is a friend
        def friend_of?(user)
          friends.include?(user)
        end

        # Assume that 'user' is already following the current user
        def become_friends_with(user)
          Friend.make_friends(self, user)
        end
        
        # Follow the given user
        def follow(user)
          Friend.add_follower(self, user)
        end
        
        def blocked?(user)
          Friend.blocked?(self, user)
        end
        
        def friendship_with(user)
          Friend.friendship_with(self, user)
        end 
        
        # Call to stop following another user
        def stop_following(user)
          Friend.stop_following(self, user)
        end
        
        # Call to remove friend or follower.  If following is enabled
        # the user specified by 'user' will become a follower of self.
        def drop_friend(user)
          if GlobalConfig.enable_following
            Friend.revert_to_follower(self, user)
          else
            Friend.stop_being_friends(self, user)
          end
        end
        
        # Block a user.  This prevents them from getting updates.
        def block_user(user)
          Friend.block_user(self, user)
        end
        
        def unblock_user(user)
          Friend.unblock_user(self, user)
        end
        
        # Indicates whether the given user is following the current user
        def followed_by?(user)
          followers.include?(user)
        end

        # Indicates whether the given user is being followed by the current user
        def following?(user)
          followings.include?(user)
        end
        
        # Indicates whether the user has any followers or friends or if they are following anybody
        def has_network?
          Friend.has_network?(self)
        end
        
      end 
    end
  end
end
