module Devcasts
  module Models
    class AuthenticateUser

      def initialize(user_info)
        @user_info = user_info
      end

      def process
        @user = User.create_or_get_from_omniauth(@user_info)
        @user.update_last_active_date!
        @user
      end
    end
  end
end
