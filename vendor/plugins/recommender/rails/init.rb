ActiveSupport::Dependencies.load_once_paths << lib_path

if config.respond_to?(:gems)
  config.gem "mbleigh-acts-as-taggable-on", :source => "http://gems.github.com", :lib => "acts-as-taggable-on"
else
  begin
    require 'acts-as-taggable-on'
  rescue LoadError
    begin
      gem 'mbleigh-acts-as-taggable-on'
    rescue Gem::LoadError
      puts "Please install the acts-as-taggable-on gem from http://gems.github.com"
    end
  end
end

require 'recommender'
require 'recommender/initialize_routes'
