namespace :test do
  namespace :engines do
    task :recreate_test_data => [ 'db:drop', 'db:create', 'db:migrate', 'db:migrate:plugins', 'db:fixtures:load', 'db:fixtures:plugins:load', 'charts:migrate' ]
  end
end