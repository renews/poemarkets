# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
if ENV['RESQUE_WORKER'] == 'true'
  RAILS_ENV = ENV['RAILS_ENV']
  ROOT_PATH = File.expand_path("..", __FILE__)
  require 'bundler'
  require 'rake'
  require 'resque/pool/tasks'
  require File.join(ROOT_PATH, 'config/initializers/redis.rb')
  import File.join(ROOT_PATH, 'lib/tasks/resque.rake')
  ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile', File.dirname(__FILE__))
  Bundler.require(:worker)
else
  require File.expand_path('../config/application', __FILE__)
  require 'resque'
  require 'resque/tasks'
  require 'resque_solo'
  Poemarkets::Application.load_tasks
end