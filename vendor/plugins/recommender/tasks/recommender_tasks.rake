namespace :recommender do
  desc "Sync files from recommender."
  task :sync do
    system "rsync -ruv vendor/plugins/recommender/db ." 
  end
  
  desc "Start the recommender daemon process"
  task :start do
    system "java"
  end
  
  desc "Stop the recommender daemon process"
  task :stop do
    system "java"
  end
  
  desc "Restart the recommender daemon process"
  task :restart do
    system "java"
  end
  
end