ROUTES_PROTOCOL = GlobalConfig.enable_ssl ? (ENV["RAILS_ENV"] =~ /(development|test)/ ? "http" : "https") : 'http'

ActionController::Routing::Routes.draw do |map|

  map.home '', :controller => 'default', :action => 'index'
  map.root :controller => 'default', :action => 'index'

  # top level pages
  map.contact '/contact', :controller => 'default', :action => 'contact'
  map.sitemap '/sitemap', :controller => 'default', :action => 'sitemap'
  map.ping '/ping', :controller => 'default', :action => 'ping'
  
  map.resources :users, :has_many => :uploads, :has_one => :profile
  map.resources :uploads, :collection => { :photos => :get, :swfupload => :post }
  map.resource :profile
  map.public_user_path '/profiles/:id', :controller => 'profiles', :action => 'show'
  
  # admin
  map.namespace :admin do |a|
    a.resource :theme
    a.resources :domain_themes
  end
  
  # muck raker specific stuff
  map.resources :oers, :controller => 'recommender/entries'
  map.connect 'oers/tags/*tags', :controller => 'recommender/entries', :action => 'browse_by_tags'
end
