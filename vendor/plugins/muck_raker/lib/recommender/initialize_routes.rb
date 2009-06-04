class ActionController::Routing::RouteSet
  def load_routes_with_recommender!
    recommender_routes = File.join(File.dirname(__FILE__), *%w[.. .. config recommender_routes.rb])
    add_configuration_file(recommender_routes) unless configuration_files.include? recommender_routes
    load_routes_without_recommender!
  end
  alias_method_chain :load_routes!, :recommender
end