ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'default', :action => 'index'
  map.resource :users, :has_many => :comments
end
