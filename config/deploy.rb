set :production_application_dir, "prod"
set :staging_application_dir, "staging"
set :rails_env, ->{ fetch(:stage) }

set :default_env, {
  "PATH" => "/home/ror/bin:/home/ror/gem/bin:$PATH",
  "GEM_HOME" => "/home/ror/gem",
  "BUNDLE_PATH" => "/home/ror/gem",
  "RUBYLIB" => "/home/ror/lib"
}

set :bundle_binstubs, nil
set :bundle_path, "/home/ror/gem"

set :application, 'worldisaparty'
set :repo_url, 'git@github.com:navidemad/worldisaparty.git'

set :conditionally_migrate, true

set :keep_assets, 2

set :db_type, :mysql

set :system_gems, "bundler ziltoid thin"
set :bundle_bins, %w{ rake rails }
set :setup_tasks, %w( gems git_user log_rotate file_upload database secrets lighttpd thin )

set :puma_threads, [4, 16]

set :deploy_ssh_keys_dir, "/Users/Navid/Development/ssh_keys/"
set :deploy_to, ->{ "/home/ror/site/#{fetch(:application_dir)}/" }
set :deploy_user, "ror"

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

append :linked_files, 'config/database.yml', 'config/secrets.yml'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

namespace :deploy do

  desc "Start application"
  task :start do
    on roles(:app), in: :sequence, wait: 3 do
      within current_path do
        execute :ruby, "/home/ror/ziltoid.rb start"
      end
    end
  end

  desc "Stop application"
  task :stop do
    on roles(:app), in: :sequence, wait: 3 do
      within current_path do
        execute :ruby, "/home/ror/ziltoid.rb stop"
      end
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence do
      within current_path do
        execute :ruby, "/home/ror/ziltoid.rb restart"
      end
    end
  end

  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  after :publishing, "deploy:setup:lighttpd"
  after :publishing, "deploy:setup:thin"
  after :publishing, "deploy:setup:ziltoid"
  after :publishing, :restart
  after :finishing, :cleanup

end
