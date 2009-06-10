ActionController::Routing::Routes.draw do |map|

  # admin
  map.namespace :admin do |a|
    a.resources :feeds, :controller => 'recommender/feeds', :member => { :harvest_now => :post, :ban => :post, :unban => :post }
  end

  map.connect '/feed_list', :controller => 'recommender/feeds', :action => 'selection_list'
  map.connect '/widgets', :controller => 'recommender/default', :action => 'widgets'
  map.connect '/tour', :controller => 'recommender/default', :action => 'tour'

  map.resources :entries, :controller => 'recommender/entries'
  map.connect 'r', :controller => 'recommender/entries', :action => 'track_clicks'
  map.connect 'entries/tags/*tags', :controller => 'recommender/entries', :action => 'browse_by_tags'
  map.connect 'entries/search/*terms', :controller => 'recommender/entries', :action => 'search'
  map.connect 'collections', :controller => 'entries', :action => 'collections'

  map.resources :recommendations, :controller => 'recommender/recommendations'

  # redirect (and hit tracking)

  # search
  map.connect 'search/relations.:format/*terms', :controller => 'search', :action => 'relations'
  map.connect 'search/relations/*terms', :controller => 'search', :action => 'relations'
  map.connect 'search/source_uri.:format', :controller => 'search', :action => 'source_uri'
  map.connect 'search/source_uri', :controller => 'search', :action => 'source_uri'
  map.connect 'search/destination_uri.:format', :controller => 'search', :action => 'destination_uri'
  map.connect 'search/destination_uri', :controller => 'search', :action => 'destination_uri'
  map.connect 'search/uris.:format', :controller => 'search', :action => 'uris'
  map.connect 'search/uris', :controller => 'search', :action => 'uris'
  map.connect 'search/results.:format', :controller => 'search', :action => 'results'
  map.connect 'search/results', :controller => 'search', :action => 'results'
  
  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '/', :controller => 'default', :action => 'index'
  map.connect '/frames', :controller => 'documents', :action => 'frames'

end