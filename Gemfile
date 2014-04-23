ruby '2.0.0'

source 'http://rubygems.org'

gem 'sinatra', require: 'sinatra/base'

gem 'omniauth'
gem 'omniauth-github'

gem 'dotenv'

gem 'mongoid'

gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

gem 'stamp'

gem 'aws-sdk', '~> 1.0'

gem 'mail'

group :development do
  gem 'shotgun'
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'database_cleaner', :github => 'bmabey/database_cleaner'
  gem 'mocha'
  gem 'factory_girl'
  gem 'rack-test'
  gem 'capybara'
end

