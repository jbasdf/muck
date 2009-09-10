class ActionController::Routing::RouteSet
  def load_routes_with_muck_users!
    muck_users_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_users_routes.rb])
    add_configuration_file(muck_users_routes) unless configuration_files.include? muck_users_routes
    load_routes_without_muck_users!
  end
  alias_method_chain :load_routes!, :muck_users
end