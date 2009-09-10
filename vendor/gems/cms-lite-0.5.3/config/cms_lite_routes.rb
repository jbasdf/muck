ActionController::Routing::Routes.draw do |map|

  CmsLite.cms_routes.each do |cms_route|
    map.connect cms_route[:uri], CmsLite.build_route_options('show_page', cms_route)
  end
  
  CmsLite.protected_cms_routes.each do |cms_route|
    map.connect cms_route[:uri], CmsLite.build_route_options('show_protected_page', cms_route)
  end

end
