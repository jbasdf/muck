require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content
class ContentTest < ActiveSupport::TestCase

  context "content" do
    setup do
      @title = 'hello'
      @body = 'hello world'
      @creator = Factory(:user)
      @content = Factory(:content, :title => @title, :body_raw => @body, :creator => @creator)
      @aaron = Factory(:user)
      @quentin = Factory(:user)
      @admin = Factory(:user)
      @admin.add_to_role('administrator')
      @editor = Factory(:user)
      @editor.add_to_role('editor')
      @user = Factory(:user)
    end

    should_belong_to :contentable
    should_belong_to :creator
    should_have_many :content_permissions
    should_have_many :content_translations
    
    should_validate_presence_of :title 
    should_validate_presence_of :body_raw
    should_validate_presence_of :locale
    
    should_have_named_scope :by_newest
    should_have_named_scope :recent
    should_have_named_scope :by_alpha
    should_have_named_scope :public
    should_have_named_scope :no_contentable
    
    should_sanitize :title
    should_sanitize :body
        
    context "translations" do
      should "have localized title" do
        assert_equal 'hola', @content.locale_title('es')
      end
      should "have localized body" do
        assert_equal 'hola mundo', @content.locale_body('es')
      end
      should "give back title" do
        assert_equal @title, @content.locale_title('en')
      end
      should "give back body" do
        assert_equal @body, @content.locale_body('en')
        assert_equal @body, @content.body
      end
      should "get a specific translation" do
        translation = @content.translation_for('es')
        assert_equal 'hola', translation.title
      end
      context "edited" do
        setup do
          @translation = @content.content_translations.first
          @translation.title = 'junk'
          @translation.user_edited = true
          @translation.save!
        end
        should "not change user edited translations" do
          @content.translate(false)
          @translation.reload
          assert_equal 'junk', @translation.title
        end
        should "change user edited translations" do
          @content.translate(true)
          @translation.reload
          assert_not_equal 'junk', @translation.title
        end
      end
    end
  
    context "uri" do
      context "global content (contentable is nil)" do
        setup do
          @path = '/a/test/path'
          @key =  'key'
          @content = Factory.build(:content, :contentable => nil)
          @content.uri = File.join(@path, @key)
          @content.save!
        end
        should "set uri_path" do
          assert_equal @path, @content.uri_path
        end
        should "set key for path" do
          assert_equal @key.titleize, @content.title
        end
        should "set get_content_scope to '/a/test/path' for use as scope in friendly_id" do
          assert_equal @path, @content.get_content_scope
        end
        should "get uri based on path" do
          assert_equal File.join(@path, @key), @content.uri
        end
      end
      context "content with contentable" do
        setup do
          @user = Factory(:user)
          @content = Factory(:content, :contentable => @user)
        end
        should "set the uri using contentable" do
          assert_equal File.join('/', @user.class.to_s.tableize, @user.to_param, @content.to_param), @content.uri
        end
      end
      context "invalid content uri" do
        setup do
          @content = Factory.build(:content, :contentable => nil)
        end
        should "indicate uri is not valid" do
          assert !@content.valid_uri?
        end
      end
      # TODO valid? is throwing exceptions even before save.
      # Uncomment test if valid? is added back into muck_content.rb
      # should "require uri if contentable is nil" do
      #   assert_no_difference 'Content.count' do
      #     u = Factory.build(:content, :contentable => nil)
      #     assert !u.valid?
      #     assert !u.errors.blank?
      #   end
      # end
    end
  
    context "singleton methods" do
      setup do
        @user = Factory(:user)
      end
      should "build path based on user object" do
        assert_equal "/users/#{@user.to_param}", Content.contentable_to_scope(@user)
      end
    end
    
    context "search" do
    end
  
    context "tags" do
      setup do
        @other_content = Factory(:content)
        @content.tag_list = 'test'
        @content.save!
      end
      should "find by tag" do
        assert Content.tagged_with('test', :on => :tags).include?(@content)
      end
      should "not find content" do
        assert !Content.tagged_with('test', :on => :tags).include?(@other_content)
      end
    end
  
    context "named scopes" do
      setup do
        @creator = Factory(:user)
        @content = Factory(:content, :creator => @creator)
        @other_content = Factory(:content)
        @contentable = Factory(:content, :contentable => @creator)
        @no_contentable = Factory(:content, :contentable => nil)
        @custom_scope = '/something-custom'
        @content_with_custom_scope = Factory(:content, :custom_scope => @custom_scope)
      end
      context "by_parent" do
        setup do
          @parent_content = Factory(:content)
          @content.move_to_child_of(@parent_content)
        end
        should "find by parent object" do
          assert Content.by_parent(@parent_content).include?(@content)
        end
        should "not find content" do
          assert !Content.by_parent(@parent_content).include?(@other_content)
        end
      end
      context "by_creator" do
        should "find by creator" do
          assert Content.by_creator(@creator).include?(@content)
        end
        should "not find content" do
          assert !Content.by_creator(@creator).include?(@other_content)
        end
      end
      context "no_contentable" do
        should "find content without contentable" do
          assert Content.no_contentable.include?(@no_contentable)
        end
        should "not find content with contentable" do
          assert !Content.no_contentable.include?(@contentable)
        end
      end
      context "by_scope" do
        should "find content by scope" do
          assert Content.by_scope(@custom_scope).include?(@content_with_custom_scope)
        end
        should "not find content not in scope" do
          assert !Content.by_scope(@custom_scope).include?(@content)
        end
      end
    end

    context "sanitize" do
      context "as admin" do
        setup do
          @content.current_editor = @admin
        end
        should "not sanitize" do
          assert_equal nil, @content.sanitize_level
        end
      end
      context "as editor" do
        setup do
          @content.current_editor = @editor
        end
        should "have relaxed sanitize" do
          assert_equal Sanitize::Config::RELAXED, @content.sanitize_level
        end
      end
      context "as user" do
        setup do
          @content.current_editor = @user
        end
        should "have basic sanitize" do
          assert_equal Sanitize::Config::BASIC, @content.sanitize_level
        end
      end
    end
  
    context "current editor" do
      setup do
        @creator = Factory(:user)
        @content = Factory(:content, :creator => @creator)
        @current_editor = Factory(:user)
      end
      should "return creator as the content editor" do
        assert_equal @creator, @content.current_editor
      end
      should "set current editor" do
        @content.current_editor = @current_editor
        assert_equal @current_editor, @content.current_editor
      end
    end
  
    context "permissions" do
      context "admin" do
        should "be able to edit content" do
          assert @content.can_edit?(@admin)
        end
      end
      context "editor" do
        should "be able to edit content" do
          assert @content.can_edit?(@editor)
        end
      end
      context "creator" do
        should "be able to edit content" do
          assert @content.can_edit?(@creator)
        end
      end
      context "other user" do
        should "not be able to edit content" do
          assert !@content.can_edit?(@aaron)
        end
      end
      should "give permissions" do
        assert !@content.can_edit?(@aaron)
        assert !@content.can_edit?(@quentin)
        @content.allow_edit(@aaron)
        assert @content.can_edit?(@aaron), "Aaron was not given edit permissions"
        @content.allow_edit(@quentin)
        assert @content.can_edit?(@quentin), "Quentin was not given edit permissions"
      end
      should "remove permissions" do
        @content.allow_edit(@quentin)
        @content.allow_edit(@aaron)
        assert @content.can_edit?(@aaron)
        @content.disallow_edit(@aaron)
        assert !@content.can_edit?(@aaron)
        assert @content.can_edit?(@quentin), "Quentin's permissions were removed along with Aaron's but should not have been." 
      end
      should "not add the same permission multple times" do
        @content.content_permissions.delete_all
        @content.allow_edit(@aaron)
        @content.allow_edit(@aaron)
        assert_equal 1, @content.content_permissions.count
      end
    end
  end
  
end