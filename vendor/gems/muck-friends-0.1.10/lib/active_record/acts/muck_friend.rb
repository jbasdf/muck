module ActiveRecord
  module Acts #:nodoc:
    module MuckFriend #:nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_friend(options = {})

          belongs_to :inviter, :class_name => 'User'
          belongs_to :invited, :class_name => 'User'
          
          include ActiveRecord::Acts::MuckFriend::InstanceMethods
          extend ActiveRecord::Acts::MuckFriend::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods

        # When enable_following is true this will setup a follower.  When enable_following is false
        # the system only allows friends and so this becomes a friend request
        def add_follower(inviter, invited)
          return false if inviter.blank? || invited.blank? || inviter == invited
          success = false
          transaction do
            friend = Friend.create(:inviter => inviter, :invited => invited, :status => MuckFriends::FOLLOWING)
            friend.add_follow_activity
            success = !friend.new_record?
          end
          success
        end

        # Called after add_follower.  This establishes a friend relationship between the two parties
        def make_friends(user, target)
          return false if user.blank? || target.blank? || user == target
          transaction do
            begin
              Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id, :status => MuckFriends::FOLLOWING}).update_attribute(:status, MuckFriends::FRIENDING)
              friend = Friend.create!(:inviter_id => target.id, :invited_id => user.id, :status => MuckFriends::FRIENDING)
              friend.add_friends_with_activity
            rescue Exception
              return make_friends(target, user) if user.followed_by?(target)
              return add_follower(user, target)
            end
          end
          true
        end

        # Destroy the frienship :(
        def stop_being_friends(user, target)
          return false if user.blank? || target.blank?
          transaction do
            friend = Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id})
            friend.destroy if friend
            friend = Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id})
            friend.destroy if friend
          end
          true
        end

        # Stop friendship with another user.  This will turn the other user into a follower
        def revert_to_follower(user, target)
          return false if user.blank? || target.blank?
          transaction do
            friend = Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id})
            friend.destroy if friend
            friend = Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id})
            if friend
              return friend.update_attribute(:status, MuckFriends::FOLLOWING)
            else
              return false
            end
          end
        end

        # User stops following target
        def stop_following(user, target)
          return false if user.blank? || target.blank?
          friend = Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id})
          if friend
            friend.destroy
          else
            false
          end
        end
        
        def block_user(user, target)
          return false if user.blank? || target.blank?
          friend = Friend.find(:first, :conditions => {:inviter_id => user.id, :invited_id => target.id})
          friend.destroy if friend
          friend = Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id})
          if friend
            friend.update_attribute(:status, MuckFriends::BLOCKED)
          else
            false
          end
        end
        
        def unblock_user(user, target)
          return false if user.blank? || target.blank?
          friend = Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id})
          if friend
            friend.update_attribute(:status, MuckFriends::FOLLOWING)
          else
            false
          end
        end

        def blocked?(user, target)
          !Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id, :status => MuckFriends::BLOCKED}).blank?
        end
        
        def has_network?(user)
          !self.find(:first, :conditions => ["invited_id = ? or inviter_id = ?", user.id, user.id]).blank?
        end
        
        def friendship_with(user, target)
          Friend.find(:first, :conditions => {:inviter_id => target.id, :invited_id => user.id})
        end
      end

      # All the methods available to a record that has had <tt>acts_as_muck_friend</tt> specified.
      module InstanceMethods
        
        def after_create
          FriendMailer.deliver_follow(inviter, invited)
        end
        
        def block
          self.update_attribute(:status, MuckFriends::BLOCKED)
        end
        
        def unblock
          self.update_attribute(:status, MuckFriends::FOLLOWING)
        end
        
        def blocked?
          # TODO status is a reserved word in mysql.  self.status won't work here (just returns nil).
          # Consider setting up 'friend' to use a state machine instead of numeric values
          # doing so would cleanup transitions between states.
          self[:status] == MuckFriends::BLOCKED
        end
        
        # Add activity that indicates user is following another user
        def add_follow_activity
          return unless GlobalConfig.enable_friend_activity
          content = I18n.t('muck.friends.follow_activity', :inviter => self.inviter.full_name, :invited => self.invited.full_name)
          add_activity(self.inviter.feed_to, self.inviter, self, 'follow', '', content)
        end

        # Add an activity that indicates the users have become friends
        def add_friends_with_activity
          return unless GlobalConfig.enable_friend_activity
          content = I18n.t('muck.friends.friends_with', :inviter => self.inviter.full_name, :invited => self.invited.full_name)
          add_activity(self.inviter.feed_to + self.invited.feed_to, self.inviter, self, 'friends_with', '', content)
        end

        def validate
          errors.add('inviter', I18n.t('muck.friends.same_inviter_error_message')) if invited == inviter
        end
        
      end 
    end
  end
end
