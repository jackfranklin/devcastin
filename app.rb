$: << File.expand_path('../', __FILE__)

require 'rubygems'
require 'bundler'

Bundler.require

Dotenv.load

require 'models'
require 'routes'

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
    # Mongoid.raise_not_found_error = false

    use OmniAuth::Builder do
      provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    end

    use Rack::Deflater

    use Routes::Index
    use Routes::Auth
    use Routes::ShowVideo


  end

end
