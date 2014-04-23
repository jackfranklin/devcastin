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
  Devcasts::App.preview_mode = false
  Devcasts::App
end

Capybara.app = app

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  :info => {
    :nickname => 'jackfranklin',
    :name => 'Jack Franklin',
    :email => 'jack@jackfranklin.net'
  }
})


RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods
  config.include Devcasts::Models
  config.mock_with :mocha
  config.before(:suite) do
    Mongoid.load!("mongoid.yml", :test)

    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  config.before(:all) do
    Devcasts::Mailer.any_instance.stubs(:send)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
