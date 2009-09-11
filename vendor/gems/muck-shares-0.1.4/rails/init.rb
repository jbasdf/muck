ActiveSupport::Dependencies.load_once_paths << lib_path # disable reloading of this plugin

require 'muck_shares'
require 'muck_shares/initialize_routes'