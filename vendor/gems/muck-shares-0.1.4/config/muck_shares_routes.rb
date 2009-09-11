ActionController::Routing::Routes.draw do |map|
  map.resources :shares, :controller => 'muck/shares'
  map.resources :users, :controller => 'muck/users' do |users|
    # have to map into the muck/shares controller or rails can't find the shares
    users.resources :shares, :controller => 'muck/shares'
  end
  
end