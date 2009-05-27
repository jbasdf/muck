namespace :recommender do
  desc "Sync files from recommender."
  task :sync do
    system "rsync -ruv vendor/plugins/recommender/db ." 
  end
end