class ActionController::Routing::RouteSet
  def load_routes_with_muck_profiles!
    muck_profiles_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_profiles_routes.rb])
    add_configuration_file(muck_profiles_routes) unless configuration_files.include? muck_profiles_routes
    load_routes_without_muck_profiles!
  end
  alias_method_chain :load_routes!, :muck_profiles
end