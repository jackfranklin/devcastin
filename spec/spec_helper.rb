require 'database_cleaner'
require 'factory_girl'
require 'capybara/rspec'
require 'rack/test'
require 'omniauth'

require_relative 'factories'
require_relative '../app'

module Devcasts
end

def app
  Devcasts::App.env = :test
  Devcasts::App
end

OmniAuth.config.test_mode = true
Capybara.app = Devcasts::App

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :mocha
  config.before(:suite) do
    Mongoid.load!("mongoid.yml", :test)

    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
