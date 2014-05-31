require 'database_cleaner'
require 'factory_girl'
require 'capybara/rspec'
require 'rack/test'
require 'omniauth'

require_relative 'factories'
require_relative '../app'
require_relative './support/feature_support'
require_relative './support/aws_stubs'
require_relative '../models/history_tracker'


module Devcasts
end

def app
  Devcasts::App.env = :test
  Devcasts::App.preview_mode = false
  Devcasts::App
end

module Rack
  class CommonLogger
    def call(env)
      # do nothing
      @app.call(env)
    end
  end
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
  config.include Features::FeatureHelpers, type: :feature
  config.mock_with :mocha
  config.before(:suite) do
    Mongoid.load!("mongoid.yml", :test)
    Mongoid::History.tracker_class_name = Devcasts::Models::HistoryTracker

    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    Devcasts::Mailer.any_instance.stubs(:send)
    AWS::S3.stubs(:new).returns(AWSStub.new)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

