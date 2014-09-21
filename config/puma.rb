workers Integer(ENV['PUMA_WORKERS'] || 1)
threads Integer(ENV['MIN_THREADS']  || 12), Integer(ENV['MAX_THREADS'] || 12)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
  if defined?(Resque)
     Resque.redis = ENV["REDIS_URL"] || "redis://127.0.0.1:6379"
  end
end