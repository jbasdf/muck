module ActiveRecord
  module Acts #:nodoc:
    module MuckFriend #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_friend(options = {})

          # Friends
          has_many :friendships, :class_name  => "Friend", :foreign_key => 'inviter_id', :conditions => "status = #{Friend::ACCEPTED}", :dependent => :destroy
          has_many :follower_friends, :class_name => "Friend", :foreign_key => "invited_id", :conditions => "status = #{Friend::PENDING}", :dependent => :destroy
          has_many :following_friends, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => "status = #{Friend::PENDING}", :dependent => :destroy

          has_many :friends,   :through => :friendships, :source => :invited
          has_many :followers, :through => :follower_friends, :source => :inviter
          has_many :followings, :through => :following_friends, :source => :invited

          has_many :friendships_initiated_by_me, :class_name => "Friend", :foreign_key => "inviter_id", :conditions => ['inviter_id = ?', self.id]
          has_many :friendships_not_initiated_by_me, :class_name => "Friend", :foreign_key => "user_id", :conditions => ['invited_id = ?', self.id]
          has_many :occurances_as_friend, :class_name => "Friend", :foreign_key => "invited_id"

          include ActiveRecord::Acts::MuckUser::InstanceMethods
          extend ActiveRecord::Acts::MuckUser::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods

      end

      # All the methods available to a record that has had <tt>acts_as_muck_user</tt> specified.
      module InstanceMethods
        
        # Friend Methods
        def friend_of? user
          user.in? friends
        end

        def followed_by? user
          user.in? followers
        end

        def following? user
          user.in? followings
        end
        
        def has_network?
          !Friend.find(:first, :conditions => ["invited_id = ? or inviter_id = ?", id, id]).blank?
        end
        
      end 
    end
  end
end
