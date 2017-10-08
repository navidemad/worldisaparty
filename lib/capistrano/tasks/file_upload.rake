namespace :deploy do
  namespace :setup do
    desc "setup Ziltoid configuration file"
    task :file_upload do
      on roles(:web, :app) do
        unless test '[ -d "/root/uploads" ]'
          execute :mkdir, "/root/uploads"
        end
      end
    end
  end
end