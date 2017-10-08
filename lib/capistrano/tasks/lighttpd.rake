namespace :deploy do
  namespace :setup do
    desc "Setup Lighttpd configuration"
    task :lighttpd do
      on roles(:app), in: :sequence do
        local_path = File.join(File.dirname(__FILE__), "../templates/lighttpd.conf.erb")
        server_path = "/root/http/lighttpd.conf"

        template = File.read(local_path)
        lighttpd_config = ERB.new(template).result(binding)

        upload! StringIO.new(lighttpd_config), server_path
        execute :chmod, "0644", server_path
      end
    end
  end
end
