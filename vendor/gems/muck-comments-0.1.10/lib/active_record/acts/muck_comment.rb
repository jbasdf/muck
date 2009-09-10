module ActiveRecord
  module Acts #:nodoc:
    module MuckComment #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_comment(options = {})

          acts_as_nested_set :scope => [:commentable_id, :commentable_type]
          validates_presence_of :body
          belongs_to :user
          belongs_to :commentable, :counter_cache => 'comment_count', :polymorphic => true, :touch => true

          named_scope :by_newest, :order => "created_at DESC"
          named_scope :by_oldest, :order => "created_at ASC"
          named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
                            
          class_eval <<-EOV
            # prevents a user from submitting a crafted form that bypasses activation
            attr_protected :created_at, :updated_at
          EOV

          include ActiveRecord::Acts::MuckComment::InstanceMethods
          extend ActiveRecord::Acts::MuckComment::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods
        
        # Helper class method to lookup all comments assigned
        # to all commentable types for a given user.
        def find_comments_by_user(user)
          find(:all,
            :conditions => ["user_id = ?", user.id],
            :order => "created_at DESC"
          )
        end

        # Helper class method to look up all comments for 
        # commentable class name and commentable id.
        def find_comments_for_commentable(commentable_str, commentable_id)
          find(:all,
            :conditions => ["commentable_type = ? and commentable_id = ?", commentable_str, commentable_id],
            :order => "created_at DESC"
          )
        end

        # Helper class method to look up a commentable object
        # given the commentable class name and id 
        def find_commentable(commentable_str, commentable_id)
          commentable_str.constantize.find(commentable_id)
        end

      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_comment</tt> specified.
      module InstanceMethods
        
        # Send an email to everyone in the thread
        def after_create
          CommentMailer.deliver_new_comment(self) if GlobalConfig.send_email_for_new_comments
        end
        
        #helper method to check if a comment has children
        def has_children?
          self.children.size > 0 
        end

        # override this method to change the way permissions are handled on comments
        def can_edit?(user)
          return true if check_user(user)
          false
        end

      end
    end
  end
end
