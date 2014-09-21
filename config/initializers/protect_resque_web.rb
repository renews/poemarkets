if Rails.env == 'production'
  require 'resque/server'
  
  Resque::Server.class_eval do
    use Rack::Auth::Basic do |username, password|
      username == ENV['RESQUE_WEB_HTTP_BASIC_AUTH_USER'] && password == ENV['RESQUE_WEB_HTTP_BASIC_AUTH_PASSWORD']
    end
  end
end