namespace :deploy do
  namespace :setup do
    desc "Init logs rotate"
    task :log_rotate do
      on roles(:app) do
        unless test '[ -d "/root/site/prod/log" ]'
          execute :mkdir, "-p /root/site/prod/shared/log"
          within "/root/site/prod" do
            execute :ln, "-s ./shared/log"
          end
        end
        unless test '[ -d "/root/site/staging/log" ]'
          execute :mkdir, "-p /root/site/staging/shared/log"
          within "/root/site/staging" do
            execute :ln, "-s ./shared/log"
          end
        end
      end
    end
  end
end
