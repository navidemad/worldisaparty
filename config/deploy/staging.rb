server "51.15.211.206", user: "root", roles: %w{app db web}
set :stage, :staging
set :rails_env, :staging
set :branch, "master"
set :application_dir, ->{ fetch(:staging_application_dir) }
