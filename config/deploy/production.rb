server "51.15.211.206", user: "root", roles: %w{app db web}
set :stage, :production
set :rails_env, :production
set :branch, "master"
