module ActiveRecord
  module Acts #:nodoc:
    module MuckFeedOwner # :nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods
        
        # +acts_as_muck_feed_owner+ adds identity feeds to a given object.  The feeds
        # attached to the object in this way are then assumed to be produced by the object.
        # For example, if a user writes a blog the blog could be associated with the user in this way.
        def acts_as_muck_feed_owner
          has_many :identity_feeds, :as => :ownable
          has_many :own_feeds, :through => :identity_feeds, :source => :feed, :order => 'created_at desc'
          include ActiveRecord::Acts::MuckFeedOwner::InstanceMethods
          extend ActiveRecord::Acts::MuckFeedOwner::SingletonMethods
        end
      end

      # class methods
      module SingletonMethods
      end
      
      module InstanceMethods
      end
      
    end
  end
end