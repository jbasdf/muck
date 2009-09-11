module ActiveRecord
  module Acts #:nodoc:
    module MuckPost #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_post(options = {})        
          belongs_to :blog, :dependent => :destroy
          include ActiveRecord::Acts::MuckPost::InstanceMethods
          extend ActiveRecord::Acts::MuckPost::SingletonMethods
        end
        
      end

      # class methods
      module SingletonMethods

      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_post</tt> specified.
      module InstanceMethods
        def after_create
          if GlobalConfig.enable_post_activities
          end
        end
      end
    end
  end
end
