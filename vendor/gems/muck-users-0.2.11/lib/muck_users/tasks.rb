require 'rake'
require 'rake/tasklib'
require 'fileutils'

module MuckUsers
  class Tasks < ::Rake::TaskLib
    def initialize
      define
    end
  
    private
    def define
      
      namespace :muck do
        namespace :users do
          desc "Sync files from muck users."
          task :sync do
            path = File.join(File.dirname(__FILE__), *%w[.. ..])
            system "rsync -ruv #{path}/db ."
            system "rsync -ruv #{path}/public ."
          end

          desc "Setup default admin user"
          task :create_admin => :environment do
            ['administrator', 'manager', 'editor', 'contributor'].each {|r| Role.create(:rolename => r) }
            user = User.new
            user.login = "admin"
            user.email = GlobalConfig.admin_email
            user.password = "asdfasdf"
            user.password_confirmation = "asdfasdf"
            user.first_name = "Administrator"
            user.last_name = "Administrator"
            user.save
            user.activate!

            user.add_to_role('administrator')

            puts 'created admin user'
          end
        end
      end
      
    end
  end
end
MuckUsers::Tasks.new