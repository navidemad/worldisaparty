namespace :deploy do
  namespace :setup do
    desc "Upload SSH keys for Git"
    task :git_user do
      on roles(:app) do
        upload! "#{fetch(:deploy_ssh_keys_dir)}id_rsa.pub",  "/root/.ssh"
        upload! "#{fetch(:deploy_ssh_keys_dir)}id_rsa",      "/root/.ssh"
        upload! "#{fetch(:deploy_ssh_keys_dir)}known_hosts", "/root/.ssh"

        execute :chmod, "600 /root/.ssh/id_rsa"
        execute :chmod, "644 /root/.ssh/id_rsa.pub"
        execute :chmod, "600 /root/.ssh/known_hosts"
      end
    end
  end
end