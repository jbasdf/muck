ROUTES_PROTOCOL = GlobalConfig.enable_ssl ? (ENV["RAILS_ENV"] =~ /(development|test)/ ? "http" : "https") : 'http'

ActionController::Routing::Routes.draw do |map|

  map.home '', :controller => 'default', :action => 'index'
  map.root :controller => 'default', :action => 'index'

  # top level pages
  map.contact '/contact', :controller => 'default', :action => 'contact'
  map.sitemap '/sitemap', :controller => 'default', :action => 'sitemap'
  map.ping '/ping', :controller => 'default', :action => 'ping'
  
  map.resources :users, :has_many => :uploads, :has_one => :profile do |users|
    # have to map into the muck/identity_feeds controller or rails can't find the identity_feeds
    users.resources :identity_feeds
    users.resources :feeds, :controller => 'muck/feeds'
  end
  
  map.resources :uploads, :collection => { :photos => :get, :swfupload => :post }
  map.resources :profiles
  map.public_user '/profiles/:id', :controller => 'profiles', :action => 'show'
  #map.logout_complete '/login', :controller => 'user_sessions', :action => 'new'
  
  
  # admin
  map.namespace :admin do |a|
    a.resource :theme
    a.resources :domain_themes
  end
  
  map.connect '/widgets', :controller => 'default', :action => 'widgets'
end
