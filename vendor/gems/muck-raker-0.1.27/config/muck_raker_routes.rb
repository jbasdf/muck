ActionController::Routing::Routes.draw do |map|

  # admin
  map.namespace :admin do |a|
    a.resources :feeds, :controller => 'muck/feeds'
  end

  map.connect '/feed_list', :controller => 'muck/feeds', :action => 'selection_list'

  map.connect 'resources/search', :controller => 'muck/entries', :action => 'search'
  map.connect 'resources/tags/*tags', :controller => 'muck/entries', :action => 'browse_by_tags'
  map.resources :resources, :controller => 'muck/entries'

  map.connect 'r', :controller => 'muck/entries', :action => 'track_clicks'
  map.connect 'collections', :controller => 'muck/entries', :action => 'collections'

  map.resources :visits, :controller => 'muck/visits'
  map.resources :feed_previews, :controller => 'muck/feed_previews', :collection => { :select_feeds => :post }
  
  map.resources :entries, :controller => 'muck/entries', :collection => { :search => :get } do |entries|
    # have to map into the muck/comments controller or rails can't find the comments
    entries.resources :comments, :controller => 'muck/comments'
  end
    
  map.resources :feeds, :controller => 'muck/feeds', :collection => { :new_extended => :get }, :has_many => :entries
  map.resources :recommendations, :controller => 'muck/recommendations'

  map.resources :identity_feeds, :controller => 'muck/identity_feeds'

  # redirect (and hit tracking)

  # search
  map.connect 'search/relations.:format/*terms', :controller => 'muck/search', :action => 'relations'
  map.connect 'search/relations/*terms', :controller => 'muck/search', :action => 'relations'
  map.connect 'search/source_uri.:format', :controller => 'muck/search', :action => 'source_uri'
  map.connect 'search/source_uri', :controller => 'muck/search', :action => 'source_uri'
  map.connect 'search/destination_uri.:format', :controller => 'muck/search', :action => 'destination_uri'
  map.connect 'search/destination_uri', :controller => 'muck/search', :action => 'destination_uri'
  map.connect 'search/uris.:format', :controller => 'muck/search', :action => 'uris'
  map.connect 'search/uris', :controller => 'muck/search', :action => 'uris'
  map.connect 'search/results.:format', :controller => 'muck/search', :action => 'results'
  map.connect 'search/results', :controller => 'muck/search', :action => 'results'

end