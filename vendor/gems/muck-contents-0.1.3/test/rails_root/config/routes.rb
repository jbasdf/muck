ActionController::Routing::Routes.draw do |map|
  map.home '', :controller => 'default', :action => 'index'
  map.root :controller => 'default', :action => 'index'
  map.resources :contents
  map.resources :users, :has_many => :contents
end
