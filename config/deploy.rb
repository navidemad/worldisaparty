# config valid only for current version of Capistrano
lock "3.9.1"

set :application, "worldisaparty"
set :repo_url, "git@example.com:me/my_repo.git"

# restart using `passenger-config restart-app`
set :passenger_restart_with_touch, false
set :passenger_in_gemfile, true

# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Clean up old assets after each deploy
set :keep_assets, 2

# Threads puma
set :puma_threads, [4, 16]

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/worldisaparty"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
