class ActionController::Routing::RouteSet
  def load_routes_with_muck_shares!
    muck_shares_routes = File.join(File.dirname(__FILE__), *%w[.. .. config muck_shares_routes.rb])
    add_configuration_file(muck_shares_routes) unless configuration_files.include? muck_shares_routes
    load_routes_without_muck_shares!
  end
  alias_method_chain :load_routes!, :muck_shares
end