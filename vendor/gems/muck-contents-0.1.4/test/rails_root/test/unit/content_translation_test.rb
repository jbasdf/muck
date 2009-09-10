require File.dirname(__FILE__) + '/../test_helper'

# Used to test muck_content_translation
class ContentTranslationTest < ActiveSupport::TestCase

  context "A content translation instance" do    
    should_belong_to :content
    should_have_named_scope :by_newest
    should_have_named_scope :recent
    should_have_named_scope :by_alpha
    should_have_named_scope :by_locale
  end
  
  context "find by locale" do
    setup do
      ContentTranslation.destroy_all
      @content_one = Factory(:content)
      @content_two = Factory(:content)
    end
    should "find two English translations" do
      translations = ContentTranslation.by_locale('en')
      assert_equal 2, translations.length
    end
    should "find two Spanish translations" do
      translations = ContentTranslation.by_locale('es')
      assert_equal 2, translations.length
    end
    should "delete translations" do
      assert_difference "ContentTranslation.count", -(@content_two.content_translations.count) do
        @content_two.destroy
      end
    end
  end
  
end