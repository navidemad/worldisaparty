# config valid only for current version of Capistrano
lock "3.9.1"

set :application, 'worldisaparty'
set :repo_url, ->{ "git@github.com:navidemad/#{ fetch(:application) }.git" }

set :rails_env, ->{ fetch(:stage) }

# folder depending of the stage
set :production_application_dir, "prod"
set :staging_application_dir, "staging"

set :bundle_binstubs, nil
set :bundle_path, "/root/gem"

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, false

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 3

set :db_type, :mysql

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, ->{ "/root/site/#{fetch(:application_dir)}/" }
set :deploy_ssh_keys_dir, "/Users/navid/.ssh/"
set :deploy_user, "root"

# Ever have files in your repo that you don't want to copy in the deploy?
# Use this to exclude any number of files / folders from a given deployment.
set :copy_exclude, [".git/"]

# Default value for :pty is false
set :pty, true
set :use_sudo, false

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads"

# Default value for default_env is {}
set :default_env, {
  path: "/root/bin:/root/gem/bin:$PATH",
  gem_home: "/root/gem",
  bundle_path: "/root/gem",
  rubylib: "/root/lib",
  tmpdir: "/var/tmp",
}
set :tmp_dir, '/var/tmp'

# Default value for keep_releases is 5
set :keep_releases, 5

set :system_gems, "bundler ziltoid"
set :bundle_bins, %w{rake rails}
set :setup_tasks, %w(gems git_user log_rotate file_upload secrets lighttpd)
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  desc "Start application"
  task :start do
    on roles(:app), in: :sequence, wait: 3 do
      within current_path do
        execute :ruby, "/root/ziltoid.rb start"
      end
    end
  end

  desc "Stop application"
  task :stop do
    on roles(:app), in: :sequence, wait: 3 do
      within current_path do
        execute :ruby, "/root/ziltoid.rb stop"
      end
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence do
      within current_path do
        execute :ruby, "/root/ziltoid.rb restart"
      end
    end
  end

  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  after :publishing, "deploy:setup:lighttpd"
  after :publishing, "deploy:setup:ziltoid"
  after :publishing, :restart
  after :finishing, :cleanup

end
