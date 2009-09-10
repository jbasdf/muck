class ActionController::Routing::RouteSet
  def load_routes_with_muck_comments!
    muck_comments_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_comments_routes.rb])
    add_configuration_file(muck_comments_routes) unless configuration_files.include? muck_comments_routes
    load_routes_without_muck_comments!
  end
  alias_method_chain :load_routes!, :muck_comments
end