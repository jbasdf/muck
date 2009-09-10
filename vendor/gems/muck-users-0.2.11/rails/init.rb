ActiveSupport::Dependencies.load_once_paths << lib_path

if config.respond_to?(:gems)
  config.gem "binarylogic-authlogic", :lib => 'authlogic', :source  => 'http://gems.github.com'
else
  begin
    require 'binarylogic-authlogic'
  rescue LoadError
    begin
      gem 'binarylogic-authlogic'
    rescue Gem::LoadError
      puts "Please install the binarylogic-authlogic gem"
    end
  end
end

if config.respond_to?(:gems)
  config.gem "binarylogic-searchlogic", :lib => 'searchlogic', :source  => 'http://gems.github.com'
else
  begin
    require 'binarylogic-searchlogic'
  rescue LoadError
    begin
      gem 'binarylogic-searchlogic'
    rescue Gem::LoadError
      puts "Please install the binarylogic-searchlogic gem"
    end
  end
end

require 'muck_users'
require 'muck_users/initialize_routes'