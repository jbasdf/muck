module ActiveRecord
  module Acts #:nodoc:
    module MuckBlogable #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def has_muck_blog
          has_one :blog, :as => :blogable, :dependent => :destroy

          include ActiveRecord::Acts::MuckBlogable::InstanceMethods
          extend ActiveRecord::Acts::MuckBlogable::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods

      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_blog</tt> specified.
      module InstanceMethods
        def after_create
          # setup a temp title using information from the parent.
          title = self.title rescue nil
          title ||= self.name rescue nil
          title ||= self.class.to_s
          title = I18n.t('muck.blogs.blog_title', :title => title)
          self.blog = Blog.create(:title => title)
        end
      end
    end
  end
end
