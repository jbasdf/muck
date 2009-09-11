module ActiveRecord
  module Has #:nodoc:
    module MuckProfile #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def has_muck_profile
          
          has_one :profile, :dependent => :destroy
          accepts_nested_attributes_for :profile, :allow_destroy => true 
          after_create {|user| user.create_profile() unless user.profile}
          delegate :photo, :to => :profile
           
          include ActiveRecord::Has::MuckProfile::InstanceMethods
          extend ActiveRecord::Has::MuckProfile::SingletonMethods
        end

      end

      # class methods
      module SingletonMethods
  
      end

      # All the methods available to a record that has had <tt>acts_as_muck_profile</tt> specified.
      module InstanceMethods
        
        
        
      end

    end
  end
end
