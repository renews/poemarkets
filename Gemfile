source 'https://rubygems.org'
ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.1'
gem 'therubyracer'

# Use pg as database
gem 'pg', group: :worker
gem 'rails_12factor', group: :worker

gem 'activerecord', group: :worker, :require => 'active_record'
gem 'activesupport', group: :worker, :require => 'active_support/all'

# New Relic tracking
gem 'newrelic_rpm', group: [:production, :worker]

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'font-awesome-sass'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# CSS Bootstrap
gem 'bootstrap-sass'
group :development do
  gem 'rails_layout'
end

# screen scraping
gem 'nokogiri', group: :worker
gem 'open_uri_redirections', group: :worker

gem 'rename', group: :development

#gem 'steam-condenser'

gem 'capybara', group: :worker
gem 'poltergeist', group: :worker
#gem 'selenium-webdriver', group: :worker

gem 'typhoeus', group: :worker

# background jobs
gem 'resque', '~> 1.25.2', group: :worker
gem 'resque_solo', group: :worker
gem 'resque-pool', group: :worker
gem 'activerecord-import', '~> 0.4.0', group: :worker
gem 'god', group: :worker

gem 'le', group: :worker


gem 'dalli'
gem 'memcachier'
#gem 'resque-web', require: 'resque_web'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
#gem 'unicorn'
gem 'puma'
gem 'rack-timeout', group: :worker
group :production do
	gem 'heroku-deflater'
	gem 'font_assets'
end

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
