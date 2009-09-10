module ActiveRecord
  module Acts #:nodoc:
    module MuckContentTranslation #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_content_translation
                    
          belongs_to :content
          
          named_scope :by_newest, :order => "content_translations.created_at DESC"
          named_scope :recent, lambda { { :conditions => ['content_translations.created_at > ?', 1.week.ago] } }
          named_scope :by_alpha, :order => "content_translations.title ASC"
          named_scope :by_locale, lambda { |locale| { :conditions => ['content_translations.locale = ?', locale] } }
                                                                                
          class_eval <<-EOV
            # prevents a user from submitting a crafted form that bypasses activation
            attr_protected :created_at, :updated_at
          EOV

          include ActiveRecord::Acts::MuckContentTranslation::InstanceMethods
          extend ActiveRecord::Acts::MuckContentTranslation::SingletonMethods
          
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
