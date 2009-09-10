module ActiveRecord
  module Acts #:nodoc:
    module MuckRakerShare # :nodoc:

      def self.included(base)
        base.extend(ClassMethods)
      end
  
      module ClassMethods

        def acts_as_muck_raker_share(options = {})
          belongs_to :entry
          include ActiveRecord::Acts::MuckRakerShare::InstanceMethods
          extend ActiveRecord::Acts::MuckRakerShare::SingletonMethods
        end
      end
      
      # class methods
      module SingletonMethods
      end

      module InstanceMethods

        def discover_attach_to
          self.entry
        end
        
      end
      
    end
  end
end