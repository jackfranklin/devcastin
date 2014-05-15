module Devcasts
  module Routes
    class UserProfile < Base
      get '/user' do
        unless signed_in?
          redirect "/"
        end

        @user = current_user
        erb :user_profile
      end
    end
  end
end
