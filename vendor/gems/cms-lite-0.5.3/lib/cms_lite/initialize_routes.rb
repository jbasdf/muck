class ActionController::Routing::RouteSet
  def load_routes_with_cms_lite!
    cms_lite_routes = File.join(File.dirname(__FILE__), *%w[.. .. config cms_lite_routes.rb])
    add_configuration_file(cms_lite_routes) unless configuration_files.include? cms_lite_routes
    load_routes_without_cms_lite!
  end
  alias_method_chain :load_routes!, :cms_lite
end