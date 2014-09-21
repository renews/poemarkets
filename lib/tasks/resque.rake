require 'resque'
require 'resque/tasks'
require 'resque_solo'

namespace :resque do
  task :setup => :resque_environment
end

task :resque_environment do
  raise "Please set RESQUE_WORKER env to true" unless ENV['RESQUE_WORKER'] == 'true'
  $:.unshift File.join(ROOT_PATH, "app/models")
  $:.unshift File.join(ROOT_PATH, "lib")
  db = YAML.load_file File.join(ROOT_PATH, "config/database.yml")
  ActiveRecord::Base.establish_connection db[RAILS_ENV]
  Dir[
    File.join(ROOT_PATH, "app/models/*.rb"),
    File.join(ROOT_PATH, "lib/*.rb")
  ].each do |f|
    name = f.split("/").last.gsub(/\.rb$/, "")
    autoload name.camelize, name
  end
end

Rake::Task.define_task(:environment)
require 'resque/pool/tasks'
# this task will get called before resque:pool:setup
# and preload the rails environment in the pool manager
task "resque:setup" => :environment do
  # generic worker setup, e.g. Hoptoad for failed jobs
end
task "resque:pool:setup" do
  # close any sockets or files in pool manager
  ActiveRecord::Base.connection.disconnect!
  # and re-open them in the resque worker parent
  Resque::Pool.after_prefork do |job|
    ActiveRecord::Base.establish_connection
  end
end