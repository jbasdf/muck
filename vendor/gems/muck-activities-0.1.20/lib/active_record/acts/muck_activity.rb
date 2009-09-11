module ActiveRecord
  module Acts #:nodoc:
    module MuckActivity #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_activity(options = {})

          belongs_to :item, :polymorphic => true
          belongs_to :source, :polymorphic => true
          belongs_to :attachable, :polymorphic => true
          has_many :activity_feeds, :dependent => :destroy
          
          acts_as_commentable

          validates_presence_of :source

          named_scope :since, lambda { |time| {:conditions => ["activities.created_at > ?", time || DateTime.now] } }
          named_scope :before, lambda { |time| {:conditions => ["activities.created_at < ?", time || DateTime.now] } }
          named_scope :newest, :order => "activities.created_at DESC"
          named_scope :oldest, :order => "activities.created_at ASC"
          named_scope :latest, :order => "activities.updated_at DESC" # Using this we can bring activites back to the top of the feed
          named_scope :after, lambda { |id| {:conditions => ["activities.id > ?", id] } }
          named_scope :only_public, :conditions => ["activities.is_public = ?", true]
          named_scope :filter_by_template, lambda { |template| { :conditions => ["activities.template = ?", template] } unless template.blank? }
          named_scope :created_by, lambda { |activity_object| {:conditions => ["activities.source_id = ? AND activities.source_type = ?", activity_object.id, activity_object.class.to_s] } }
          named_scope :status_updates, :conditions => ["activities.is_status_update = ?", true]
          named_scope :by_item, lambda { |item| { :conditions => ["activities.item_id = ? AND activities.item_type = ?", item.id, item.class.to_s] } unless item.blank? }
          class_eval <<-EOV
            attr_protected :created_at, :updated_at
          EOV

          include ActiveRecord::Acts::MuckActivity::InstanceMethods
          extend ActiveRecord::Acts::MuckActivity::SingletonMethods

        end
      end

      # class methods
      module SingletonMethods
  
      end

      # All the methods available to a record that has had <tt>acts_as_muck_activity</tt> specified.
      module InstanceMethods

        def validate
          errors.add_to_base(I18n.t('muck.activities.template_or_item_required')) if template.blank? && item.blank?
        end

        # Provides a template that can be used to render a view of this activity.
        # If 'template' is not specified when the object created then the item class
        # name will be used to generated a template
        def partial
          template || item.class.name.underscore
        end

        def has_comments?
          @has_comments ||= !self.comments.blank?
        end

        # Checks to see if the specified object can edit this activity.
        # Most likely check_object will be a user
        def can_edit?(check_object)
          if check_object.is_a?(User)
            return true if check(check_object, :source_id)
          else
            source == check_object
          end
          false
        end
        
      end

    end
  end
end
