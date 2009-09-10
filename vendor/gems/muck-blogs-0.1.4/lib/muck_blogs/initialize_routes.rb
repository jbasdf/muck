class ActionController::Routing::RouteSet
  def load_routes_with_muck_blogs!
    muck_blogs_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_blogs_routes.rb])
    add_configuration_file(muck_blogs_routes) unless configuration_files.include? muck_blogs_routes
    load_routes_without_muck_blogs!
  end
  alias_method_chain :load_routes!, :muck_blogs
end