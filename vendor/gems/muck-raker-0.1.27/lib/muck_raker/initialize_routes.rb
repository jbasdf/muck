class ActionController::Routing::RouteSet
  def load_routes_with_muck_raker!
    muck_raker_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_raker_routes.rb])
    add_configuration_file(muck_raker_routes) unless configuration_files.include? muck_raker_routes
    load_routes_without_muck_raker!
  end
  alias_method_chain :load_routes!, :muck_raker
end