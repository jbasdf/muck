CmsLite.cms_layouts = { :default => 'default' }
#CmsLite.append_content_path("themes/#{Theme.first}/content") if File.exists?("#{RAILS_ROOT}/themes/#{Theme.first}/content")

CmsLite.append_content_path('themes/folksemantic/content')
