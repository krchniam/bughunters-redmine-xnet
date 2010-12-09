set :application, "bughunters"
set :repository, "git://github.com/draxberg/bughunters-redmine-xnet.git"
set :scm, "git"

role :web, "server3.railshosting.cz"
role :app, "server3.railshosting.cz"
role :db,  "server3.railshosting.cz", :primary => true

set :deploy_to, "/home/bughunters/app/"
set :user, "bughunters"

set :use_sudo, false

task :after_update_code, :roles => [:app, :db] do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "rm -rf #{release_path}/files"
  run "ln -nfs #{shared_path}/files #{release_path}"
end


namespace :deploy do
  task :start, :roles => :app do
  end

  desc "Upgradne redmine - vykona db migracie + migracie pluginov, zaverecny cleanu a vygenerovanie session_store"
  task :upgrade, :roles => :app do
   run "cd #{release_path} && rake generate_session_store"
   run "cd #{release_path} && rake db:migrate RAILS_ENV=production"
   run "cd #{release_path} && rake db:migrate_plugins RAILS_ENV=production"
   run "cd #{release_path} && rake tmp:cache:clear"
   run "cd #{release_path} && rake tmp:sessions:clear"
  end
end

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
