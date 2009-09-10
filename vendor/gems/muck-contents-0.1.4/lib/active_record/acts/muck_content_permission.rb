module ActiveRecord
  module Acts #:nodoc:
    module MuckContentPermission #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_content_permission

          belongs_to :content
          belongs_to :user

          named_scope :by_user, lambda { |user| { :conditions => ['content_permissions.user_id = ?', user.id] } }

          class_eval <<-EOV
            # prevents a user from submitting a crafted form that bypasses activation
            attr_protected :created_at, :updated_at
          EOV

          include ActiveRecord::Acts::MuckContentPermission::InstanceMethods
          extend ActiveRecord::Acts::MuckContentPermission::SingletonMethods
          
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
