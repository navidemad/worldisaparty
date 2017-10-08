port = self.get("binds")[0].scan( /\d+$/ ).first
environment "production"
directory "/root/site/#{fetch(:prod_application_dir)}/current/"
force_shutdown_after 2 if respond_to?(:force_shutdown_after)
stdout_redirect "/root/site/#{fetch(:prod_application_dir)}/shared/log/puma.#{port}.stdout.log", "/root/site/#{fetch(:prod_application_dir)}/shared/log/puma.#{port}.stderr.log"
pidfile "/root/http/tmp/puma.#{port}.pid"
state_path "/root/http/tmp/puma.#{port}.state"
persistent_timeout 30
