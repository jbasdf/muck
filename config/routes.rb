ActionController::Routing::Routes.draw do |map|

  map.home '', :controller => 'default', :action => 'index'
  map.root :controller => 'default', :action => 'index'

  # top level pages
  map.contact '/contact', :controller => 'default', :action => 'contact'
  map.sitemap '/sitemap', :controller => 'default', :action => 'sitemap'
  map.ping '/ping', :controller => 'default', :action => 'ping'
  
  map.resources :users, :has_many => :uploads
  map.resources :uploads, :collection => { :photos => :get, :swfupload => :post }
  map.public_user_path '/profiles/:id', :controller => 'profiles', :action => 'show'

  # admin
  map.namespace :admin do |a|
    a.resource :theme
    a.resources :domain_themes
  end
  
  map.resources :oers, :controller => 'recommender/entries'
end
