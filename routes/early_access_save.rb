module Devcasts
  module Routes
    class EarlyAccessSave < Base
      post '/early_access' do
        EarlyAccess.new(email: params[:email]).save
        redirect "/?saved=true"
      end
    end
  end
end
