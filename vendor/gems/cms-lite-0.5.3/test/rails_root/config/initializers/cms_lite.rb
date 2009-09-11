CmsLite.cms_layouts = { :default => 'default' }
CmsLite.append_content_path('themes/blue/content', false)
CmsLite.append_content_path('themes/red/content', false)
ActionController::Routing::Routes.reload!