ActionController::Routing::Routes.draw do |map|
  map.resources :activities, :controller => 'muck/activities'
end