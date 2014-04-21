require 'json'

module Devcasts
  module Routes
    class Auth < Base
      get "/auth/github/callback" do
        user_info = request.env['omniauth.auth']['info']
        user = User.create_or_get_from_omniauth(
          nickname: user_info['nickname'],
          name: user_info['name'],
          email: user_info['email']
        )
        user.save
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
