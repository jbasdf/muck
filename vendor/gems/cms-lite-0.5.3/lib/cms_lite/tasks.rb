require 'rake'
require 'rake/tasklib'
require 'fileutils'

class CmsLite
  class Tasks < ::Rake::TaskLib
    def initialize
      define
    end
  
    private
    def define
      namespace :cms_lite do
        
        task :app_env do
          Rake::Task[:environment].invoke if defined?(RAILS_ROOT)
        end
        
        desc 'Translate all pages in the given language directory to all other languages.  Pass a language with language=en, language=ja, etc'
        task :translate do
          language = ENV['language'] || 'en'
          CmsLite.translate_pages(language)
        end
        
        desc 'Create basic directory structure for cms lite'  
        task :setup => :app_env do
          page_path = "#{RAILS_ROOT}/content/pages/en/cmslite"
          protected_path = "#{RAILS_ROOT}/content/protected-pages/en/cmslite-protected"
          FileUtils.mkdir_p(page_path) unless File.directory?(page_path)
          FileUtils.mkdir_p(protected_path) unless File.directory?(protected_path)
          File.open("#{page_path}/hello-world.htm", 'w') {|f| f.write("Hello World") }
          File.open("#{protected_path}/hello-world.htm", 'w') {|f| f.write("Hello World") }    
          puts "finished setting up cmslite directories"
        end
        
      end
    end
  end
end
CmsLite::Tasks.new