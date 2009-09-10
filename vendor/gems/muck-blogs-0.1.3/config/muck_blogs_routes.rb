ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :controller => 'muck/posts'
  map.resources :blogs, :controller => 'muck/blogs' do |blogs|
    blogs.resources :posts, :controller => 'muck/posts'
  end
end
