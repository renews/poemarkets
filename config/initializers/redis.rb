require 'redis'
require 'resque'
uri = URI.parse(ENV['REDIS_URL'] || 'redis://root@localhost:6379')
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis = $redis