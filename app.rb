$: << File.expand_path('../', __FILE__)

require 'rubygems'
require 'bundler'

Bundler.require

Dotenv.load

require 'models'
require 'routes'
require 'mailer'

require 'mongoid'

module Devcasts
  class App < Sinatra::Application
    configure do
      disable :method_override
      disable :static

      set :sessions,
          :httponly     => true,
          :secure       => false,
          :expire_after => 31557600, # 1 year
          :secret       => ENV['SESSION_SECRET']
    end

    Mongoid.load!("mongoid.yml", ENV['RACK_ENV'])

    Stripe.api_key = ENV["STRIPE_TEST_SECRET"]

    use OmniAuth::Builder do
      provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    end

    AWS.config(
      :access_key_id => ENV["S3_ACCESS"],
      :secret_access_key => ENV["S3_SECRET"]
    )

    use Rack::Deflater

    use Routes::Index
    use Routes::Auth
    use Routes::NewPurchase
    use Routes::ShowVideo
    use Routes::UserProfile
    use Routes::Admin
    use Routes::Archive
    use Routes::About
    use Routes::Search
    use Routes::EarlyAccessSave

  end

end
