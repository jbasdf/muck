class ActionController::Routing::RouteSet
  def load_routes_with_muck_contents!
    muck_contents_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_contents_routes.rb])
    add_configuration_file(muck_contents_routes) unless configuration_files.include? muck_contents_routes
    load_routes_without_muck_contents!
  end
  alias_method_chain :load_routes!, :muck_contents
end