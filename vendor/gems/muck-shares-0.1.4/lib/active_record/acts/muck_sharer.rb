module ActiveRecord
  module Acts #:nodoc:
    module MuckSharer #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_sharer(options = {})
          has_many :shares, :dependent => :destroy, :order => 'created_at ASC', :foreign_key => :shared_by_id
          include ActiveRecord::Acts::MuckSharer::InstanceMethods
          extend ActiveRecord::Acts::MuckSharer::SingletonMethods
        end
      end

      # class methods
      module SingletonMethods

      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_share</tt> specified.
      module InstanceMethods

      end
    end
  end
end