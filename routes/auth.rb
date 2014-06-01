require 'json'

module Devcasts
  module Routes
    class Auth < Base
      get "/auth/github/callback" do
        user_info = request.env['omniauth.auth']['info']
        user = AuthenticateUser.new(user_info).process
        session[:user_id] = user.id
        redirect "/"
      end

      get "/logout" do
        session[:user_id] = nil
        redirect "/"
      end
    end
  end
end
