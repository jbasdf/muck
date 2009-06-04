namespace :recommender do
  desc "Sync files from recommender."
  task :sync do
    system "rsync -ruv vendor/plugins/recommender/db ." 
  end
  
  desc "Start the recommender daemon process"
  task :start do
    Dir.chdir(File.join(RAILS_ROOT, 'vendor', 'plugins', 'muck_raker', 'raker', 'lib')) do
      jars = Dir['*.jar'].join(';')
      puts "java -classpath #{jars};. -jar recommenderd.jar"
      exec "java -classpath #{jars};. -jar recommenderd.jar"  
    end
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