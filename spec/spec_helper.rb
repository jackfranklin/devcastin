require 'database_cleaner'
require 'factory_girl'
require_relative 'factories'

require 'rack/test'
require 'omniauth'


module Devcasts
end

OmniAuth.config.test_mode = true

RSpec.configure do |config|
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
