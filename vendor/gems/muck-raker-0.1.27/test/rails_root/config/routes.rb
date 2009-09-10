ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'default', :action => 'index'
  
  map.resources :users, :controller => 'muck/users' do |users|
    # have to map into the muck/identity_feeds controller or rails can't find the identity_feeds
    users.resources :identity_feeds, :controller => 'muck/identity_feeds'
    users.resources :feeds, :controller => 'muck/feeds'
  end
  
end
