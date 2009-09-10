require 'friendly_id'
require 'acts_as_solr'

module ActiveRecord
  module Acts #:nodoc:
    module MuckContent #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        
        def acts_as_muck_content(options = {})
          
          default_options = { 
            :sanitize_content => true,
            :enable_auto_translations => true,
            :enable_solr => false
          }
          options = default_options.merge(options)
          
          acts_as_nested_set :scope => [:contentable_id, :contentable_type]
          acts_as_taggable
          acts_as_commentable
                    
          validates_presence_of :title 
          validates_presence_of :body_raw
          validates_presence_of :locale
          
          belongs_to :contentable, :polymorphic => true
          belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
          has_many   :content_permissions, :dependent => :destroy
          has_many   :content_translations, :dependent => :destroy

          named_scope :by_newest, :order => "created_at DESC"
          named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
          named_scope :by_alpha, :order => "title ASC"
          named_scope :public, :conditions => "is_public = true"
          named_scope :by_parent, lambda { |parent_id| { :conditions => ['parent_id = ?', parent_id || 0] } }
          named_scope :by_creator, lambda { |creator_id| { :conditions => ['creator_id = ?', creator_id || 0] } }
          named_scope :no_contentable, :conditions => 'contentable_id IS NULL'
          # include the '/' in case the user forgets.  Note 'get_content_scope' will add the '/' so 
          # if we don't include it here the content won't be found as the scope won't match up. 
          named_scope :by_scope, lambda { |scope| { :conditions => ["slugs.scope = ?", File.join('/', scope)], :include => [:slugs] } } 
          
          has_friendly_id :title, :use_slug => true, :scope => :get_content_scope

          if options[:sanitize_content]
            before_save :sanitize_attributes
          end

          # TODO add states - draft, published
          # maybe move content body_raw -> body_draft -> body
          # then you could be working on a revision without it being live

          # TODO add versions
          # if options[:git_repository]
          #   versioning(:title) do |version|
          #     version.repository = options[:git_repository]
          #     version.message = lambda { |content| "Committed by #{content.author.name}" }
          #   end
          # end

          if options[:enable_auto_translations]
            after_save :auto_translate
          end

          if options[:enable_solr]
            acts_as_solr({ :fields => [ :search_content => 'string' ] }, { :multi_core => true, :default_core => 'en' })
          end

          class_eval <<-EOV
            attr_accessor :uri_path
            attr_accessor :custom_scope
            
            # prevents a user from submitting a crafted form that bypasses activation
            attr_protected :created_at, :updated_at, :creator, :body
          EOV

          include ActiveRecord::Acts::MuckContent::InstanceMethods
          extend ActiveRecord::Acts::MuckContent::SingletonMethods
          
        end
      end

      # class methods
      module SingletonMethods

        # Look up all contents for contentable
        def find_contents_for_contentable(contentable_type, contentable_id)
          find(:all,
            :conditions => ["contentable_type = ? and contentable_id = ?", contentable_type, contentable_id],
            :order => "created_at DESC"
          )
        end

        # look up a contentable object given the contentable class name and id 
        def find_contentable(contentable_type, contentable_id)
          contentable_type.constantize.find(contentable_id)
        end

        # Builds a path based on a contentable object.
        # This is the value used to generate scope for the content object.
        def contentable_to_scope(obj)
          File.join('/', obj.class.to_s.tableize, obj.to_param)
        end
        
        def id_from_uri(uri)
          File.basename(uri)
        end
        
        def scope_from_uri(uri)
          File.dirname(uri)
        end
        
      end
      
      # All the methods available to a record that has had <tt>acts_as_muck_content</tt> specified.
      module InstanceMethods
        
        # Uri that will identify this content on the website
        # Splits up a uri into a path part and a key part that will automatically be assigned to the title.
        # For example:
        # given /faq/widgets/the_green_one
        # will assign uri_path = faq/widgets
        # and return the key the_green_one
        def uri=(val)
          self.title = self.class.id_from_uri(val)
          if self.title
            self.title = self.title.titleize 
          end
          self.uri_path = self.class.scope_from_uri(val)
        end
        
        # The model must be saved before uri becomes valid.  It is calculated using
        # the model's scope and id
        def uri
          File.join(self.scope, self.to_param)
        end
        
        # get scope from the slug
        def scope
          self.slug.scope
        end
        
        # TODO for some reason if valid? fails even before save an exception is being thrown.
        # Uncomment this method if you figure out why.
        # if contentable is blank then a uri that identifies this content must be specified
        # def valid?
        #   if !valid_uri?
        #     errors.add_to_base(I18n.t('muck.contents.no_uri_error'))
        #   end
        # end
        
        def valid_uri?
          !self.contentable.blank? || !self.uri_path.blank?
        end
        
        # Setup the scope for this content object
        def get_content_scope
          if !self.custom_scope.blank?
            File.join('/', self.custom_scope) # make sure the scope starts with a '/'
          elsif !self.contentable.blank?
            self.class.contentable_to_scope(self.contentable)
          else
            if self.uri_path
              self.uri_path
            else
              MuckContents::GLOBAL_SCOPE
            end
          end
        end
        
        # Returns a title specific to the provided locale
        def locale_title(current_locale)
          if self.locale != current_locale
            setup_locale(current_locale)
            return @locale_contents[current_locale].title if @locale_contents[current_locale]
          end
          self.title
        end
        
        # Returns a body specific to the provided locale
        def locale_body(current_locale)
          if self.locale != current_locale
            setup_locale(current_locale)
            return @locale_contents[current_locale].body if @locale_contents[current_locale]
          end
          self.body
        end

        # Provided for solr index.  Override this method if you wish to add
        # other fields/data to the solr index.
        def search_content
          "#{body}"
        end

        # Called after 'save' if auto translate is enabled
        def auto_translate
          begin
            translate(false)
          rescue => ex
            #TODO figure out a way to bubble up the error
            puts ex
          end
        end
        
        # Translate title and body using Google
        def translate(overwrite_user_edited_translations = false)
          title_translations = Babelphish::Translator.multiple_translate(self.title, Babelphish::GoogleTranslate::LANGUAGES, self.locale)
          body_translations = Babelphish::Translator.multiple_translate(self.body, Babelphish::GoogleTranslate::LANGUAGES, self.locale)
          existing_translations = {}
          self.content_translations.each do |translation|
            existing_translations[translation.locale] = translation
          end
          
          Babelphish::GoogleTranslate::LANGUAGES.each do |language|
            if translation = existing_translations[language]
              if !translation.user_edited || overwrite_user_edited_translations
                translation.update_attributes!(:title => title_translations[language],
                                              :body => body_translations[language])
              end
            else
              self.content_translations.create!(:title => title_translations[language],
                                                :body => body_translations[language],
                                                :locale => language)
            end
          end
        end

        def translation_for(locale)
          self.content_translations.by_locale(locale).first
        end

        # Set the user who is currently editing the content.  This is used
        # to determine permissions
        def current_editor=(editor)
          @current_editor = editor
        end
        
        # Get the user that is currently editing the content
        def current_editor
          @current_editor || creator
        end

        # Sanitize content before saving.  This prevent XSS attacks and other malicious html.
        def sanitize_attributes
          if self.sanitize_level
            self.body = Sanitize.clean(self.body_raw, self.sanitize_level)
            self.title = Sanitize.clean(self.title, self.sanitize_level)
          else
            self.body = self.body_raw
          end
        end
        
        # Override this method to control sanitization levels.
        # Currently a user who is an admin will not have their content sanitized.  A user
        # in any role 'editor', 'manager', or 'contributor' will be given the 'RELAXED' settings
        # while all other users will get 'BASIC'.
        #
        # By default the 'creator' of the content will be used to determine which level of
        # sanitization is allowed.  To change this set 'current_editor' before
        #
        # Options are from sanitze:
        # nil - no sanitize
        # Sanitize::Config::RELAXED
        # Sanitize::Config::BASIC
        # Sanitize::Config::RESTRICTED
        # for more details see: http://rgrove.github.com/sanitize/
        def sanitize_level
          return Sanitize::Config::BASIC if current_editor.nil?
          return nil if current_editor.admin?
          return Sanitize::Config::RELAXED if current_editor.any_role?('editor', 'manager', 'contributor')
          Sanitize::Config::BASIC
        end
        
        # Override this method to change the way edit permissions are handled on contents
        # By default the creator or a user in the roles 'editor', 'manager' or 'admin' can edit the object
        # If the content is owned by some object such as a group or project then you might change this method
        # to let members of the group or project edit the content.
        def can_edit?(user)
          return true if check_creator(user)
          return true if user.any_role?('editor', 'manager')
          return true if !self.content_permissions.by_user(user).blank?
          return true if self.parent && self.parent.can_add_content?(user)
          false
        end

        # Give permissions to a specific user to edit this content
        def allow_edit(user)
          permission = self.content_permissions.by_user(user).first
          if !permission # Make sure the user is only added once
            permission = self.content_permissions.create(:user => user)
          end
          permission
        end
        
        # Remove permissions from a specific user
        def disallow_edit(user)
          self.content_permissions.by_user(user).destroy_all
        end
        
        protected
        
          def setup_locale(current_locale)
            @locale_contents ||= {}
            @locale_contents[current_locale] ||= self.translation_for(current_locale.to_s)
          end
          
      end
    end
  end
end
