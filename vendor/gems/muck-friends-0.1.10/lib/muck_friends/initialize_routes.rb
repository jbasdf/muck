class ActionController::Routing::RouteSet
  def load_routes_with_muck_friends!
    muck_friends_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_friends_routes.rb])
    add_configuration_file(muck_friends_routes) unless configuration_files.include? muck_friends_routes
    load_routes_without_muck_friends!
  end
  alias_method_chain :load_routes!, :muck_friends
end