# config/initializers/timeout.rb
require 'rack-timeout'
Rack::Timeout.timeout = 25  # seconds