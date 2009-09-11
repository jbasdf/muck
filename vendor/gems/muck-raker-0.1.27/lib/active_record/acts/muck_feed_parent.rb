module ActiveRecord
  module Acts #:nodoc:
    module MuckFeedParent # :nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods

        # +has_muck_feeds+ gives the class it is called on access to feeds.
        # Retrieve feeds via object.feeds. ie @user.feeds.
        # This is used to indicate which feeds a user would like to have access to.
        def has_muck_feeds
          has_many :feed_parents, :as => :ownable
          has_many :feeds, :through => :feed_parents, :order => 'created_at desc'
        end

      end

    end
  end
end