ActiveSupport::Dependencies.load_once_paths << lib_path # disable reloading of this plugin

require 'muck_comments'
require 'muck_comments/initialize_routes'