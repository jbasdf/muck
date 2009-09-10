ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'default', :action => 'index'
  map.resources :users do |users|
    users.resource :blog, :controller => 'muck/blogs' do |blog|
      blog.resources :posts, :controller => 'muck/posts'
    end
  end
end

