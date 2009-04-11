namespace :muck do
  namespace :blurb do
    desc "Sync required files from blurb engine."
    task :sync do
      system "rsync -ruv vendor/plugins/muck_activity_engine/db ."
    end
  end
end