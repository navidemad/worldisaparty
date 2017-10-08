#! /usr/bin/env ruby

require 'ziltoid'

SHARED_PATH_PRODUCTION = "/root/site/prod/shared"
CURRENT_PATH_PRODUCTION = "/root/site/prod/current"
HTTP_CONF_PATH = "/root/http"
BIN_PATH = "/root/bin"
GEM_BIN_PATH = "/root/gem/bin"
PID_PATH = "/root/http/tmp"
BUNDLE_EXEC = "#{GEM_BIN_PATH}/bundle exec"

watcher = Ziltoid::Watcher.new(
  logger: Logger.new(File.new("#{SHARED_PATH_PRODUCTION}/log/ziltoid.log", 'a+')),
  progname: 'Ziltoid Watcher',
  log_level: Logger::DEBUG,
  notifiers: []
)

[4567, 4568].each do |port|
  watcher.add(Ziltoid::Process.new("puma - production - #{port}", {
    pid_file: "#{PID_PATH}/puma.#{port}.pid",
    commands: {
      start: "cd #{CURRENT_PATH_PRODUCTION} 2> /dev/null && RAILS_ENV=production PORT=#{port} #{BUNDLE_EXEC} puma -C config/puma.rb -d --pidfile #{PID_PATH}/puma.#{port}.pid -S #{PID_PATH}/puma.#{port}.state --dir=#{CURRENT_PATH_PRODUCTION}/ --redirect-stdout=#{SHARED_PATH_PRODUCTION}/log/puma.#{port}.stdout.log --redirect-stderr=#{SHARED_PATH_PRODUCTION}/log/puma.#{port}.stderr.log",
      stop: "cd #{CURRENT_PATH_PRODUCTION} 2> /dev/null && #{BUNDLE_EXEC} pumactl --state #{PID_PATH}/puma.#{port}.state stop && rm -f #{PID_PATH}/puma.#{port}.pid"
    },
    limit: {
      ram: 256,
      cpu: 40
    }
  }))
end

watcher.add(Ziltoid::Process.new("Lighty", {
  pid_file: "#{PID_PATH}/lighttpd.pid",
  commands: {
    start: "#{BIN_PATH}/lighty start",
    stop: "#{BIN_PATH}/lighty stop"
  },
  limit: {
    ram: 256,
    cpu: 10
  }
}))

runnable = Ziltoid::CommandParser.parse(ARGV)
watcher.run(runnable.command.to_sym)
