require 'json'

module Devcasts
  module Routes
    class Auth < Base
      get '/auth/github/callback' do
        p request.env['omniauth.auth']
        request.env['omniauth.auth'].to_json
      end
    end
  end
end
