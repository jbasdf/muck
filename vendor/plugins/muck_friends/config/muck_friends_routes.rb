ActionController::Routing::Routes.draw do |map|
  map.resources :users, :has_many => [:friends]
end
