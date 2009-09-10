ActionController::Routing::Routes.draw do |map|
  map.resources :friends, :controller => 'muck/friends'
  map.resources :users do |users|
    users.resources :friends, :controller => 'muck/friends'
  end
end
