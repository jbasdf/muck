ActiveSupport::Dependencies.load_once_paths << lib_path # disable reloading of this plugin

require 'muck_blogs'
require 'muck_blogs/initialize_routes'