ActionController::Routing::Routes.draw do |map|
  map.resources :comments, :controller => 'muck/comments'
end
