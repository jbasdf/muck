ActionController::Routing::Routes.draw do |map|
  map.resources :contents, :controller => 'muck/contents'
  
  # MuckContents.routes.each do |route|
  #   map.connect route[:uri], MuckContents.build_route_options(route)
  # end
  
end
