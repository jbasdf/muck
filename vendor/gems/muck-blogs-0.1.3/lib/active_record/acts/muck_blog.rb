module ActiveRecord
  module Acts #:nodoc:
    module MuckBlog #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_blog(options = {})
          
          has_many :posts, :as => :contentable, :class_name => 'Content'
          belongs_to :blogable, :polymorphic => true

          has_friendly_id :title, :use_slug => true, :scope => :get_blog_scope
          
          validates_presence_of :title
          
          named_scope :by_newest, :order => "created_at DESC"
          named_scope :by_oldest, :order => "created_at ASC"
          named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
                            
          class_eval <<-EOV
            # prevents a user from submitting a crafted form that changes audit values
            attr_protected :created_at, :updated_at
          EOV

          include ActiveRecord::Acts::MuckBlog::InstanceMethods
          extend ActiveRecord::Acts::MuckBlog::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods
        def blogable_to_scope(obj)
          File.join('/', obj.class.to_s.tableize, obj.to_param)
        end
      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_blog</tt> specified.
      module InstanceMethods

        # Setup the scope for this content object
        def get_blog_scope
          if self.blogable_id > 0 && !self.blogable_type.blank?
            self.class.blogable_to_scope(self.blogable)
          else
            ''
          end
        rescue
          debugger
          t = 0
        end
        
        # Determines whether or not the given user has the right to add content to the blog
        # Override this method to change permissions.
        # Currently this method looks to the parent object and calls 'can_edit?' to determine
        # whether or not the user can edit the content
        def can_add_content?(user)
          blogable.can_edit?(user)
        end

      end
    end
  end
end
