module Devcasts
  module Routes
    class UserProfile < Base
      get '/user' do
        unless signed_in?
          redirect "/"
        end

        @user = current_user
        @videos = @user.videos
        erb :user_profile
      end

      post '/user/add_coupon' do
        unless signed_in?
          redirect "/"
        end

        code = params[:coupon_code]
        current_user.use_coupon_code!(code)

        redirect '/user'
      end
    end
  end
end
