require 'rake'
require 'rake/tasklib'
require 'fileutils'

module MuckBlogs
  class Tasks < ::Rake::TaskLib
    def initialize
      define
    end
  
    private
    def define
      
      namespace :muck do
        namespace :blogs do
          desc "Sync required files from muck blogs."
          task :sync do
            path = File.join(File.dirname(__FILE__), *%w[.. ..])
            system "rsync -ruv #{path}/db ."
            #system "rsync -ruv #{path}/public ."
          end
        end
      end

    end
  end
end
MuckBlogs::Tasks.new