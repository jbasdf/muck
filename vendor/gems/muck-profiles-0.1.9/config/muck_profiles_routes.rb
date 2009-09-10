ActionController::Routing::Routes.draw do |map|

  # profiles
  map.resources :profiles, :controller => 'muck/profiles'
  map.resources :users, :has_one => :profile

  # admin
  map.namespace :admin do |a|
    a.resources :profiles, :controller => 'muck/profiles'
  end

end
