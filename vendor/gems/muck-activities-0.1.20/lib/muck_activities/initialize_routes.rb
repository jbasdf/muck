class ActionController::Routing::RouteSet
  def load_routes_with_muck_activities!
    muck_activities_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_activities_routes.rb])
    add_configuration_file(muck_activities_routes) unless configuration_files.include? muck_activities_routes
    load_routes_without_muck_activities!
  end
  alias_method_chain :load_routes!, :muck_activities
end