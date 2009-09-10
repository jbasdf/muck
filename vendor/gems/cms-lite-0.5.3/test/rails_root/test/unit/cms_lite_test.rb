
require File.dirname(__FILE__) + '/../test_helper'

class CmsLiteTest < ActiveSupport::TestCase

  context "cms lite" do
    
    should "provide routes to #{CmsLite::CONTENT_PATH}/#{CmsLite::PAGES_PATH}" do
      found = false
      CmsLite.cms_routes.each do |route|
        if route[:content_key] == '/demo' && route[:uri] == '/demo/*content_page'
          found = true
        end
      end
      assert found
    end
    
    should "provide routes to #{CmsLite::CONTENT_PATH}/#{CmsLite::PROTECTED_PAGES_PATH}" do
      found = false
      CmsLite.protected_cms_routes.each do |route|
        if route[:content_key] == '/protected' && route[:uri] == '/protected/*content_page'
          found = true
        end
      end
      assert found
    end
    
    should "find overlapping routes" do
      found = false
      CmsLite.check_routes.each do |route|
        if route[:content_key] == '/demo' && route[:uri] == '/demo/*content_page'
          found = true
        end
      end
      assert found
    end
    
    should "not find overlapping routes" do
      found = false
      CmsLite.check_routes.each do |route|
        if route[:content_key] == '/open' && route[:uri] == '/open/*content_page'
          found = true
        end
      end
      assert !found
    end
    
    should "add new open content path" do
      CmsLite.append_content_path('themes/blue/content')
      found = false
      CmsLite.cms_routes.each do |route|
        if route[:content_key] == '/blue' && route[:uri] == '/blue/*content_page'
          found = true
        end
      end
      assert found
    end
      
    should "add new protected content path" do
      CmsLite.append_content_path('themes/red/content')
      found = false
      CmsLite.protected_cms_routes.each do |route|
        if route[:content_key] == '/red' && route[:uri] == '/red/*content_page'
          found = true
        end
      end
      assert found
    end
    
    should "remove content path" do
      CmsLite.append_content_path('themes/red/content')
      CmsLite.remove_content_path('themes/red/content')
      found = false
      CmsLite.protected_cms_routes.each do |route|
        if route[:content_key] == '/red' && route[:uri] == '/red/*content_page'
          found = true
        end
      end
      assert !found      
    end
    
  end

end