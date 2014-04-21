require 'json'

module Devcasts
  module Routes
    class Base < Sinatra::Application
      # error Models::NotFound do
      #   error 404
      # end

      include Devcasts::Models

      error Mongoid::Errors::DocumentNotFound do
        content_type :json
        { error: 'mongoid no found' }.to_json
      end

      helpers do
        def signed_in?
          !session[:user_id].nil?
        end

        def current_user
          if signed_in?
            User.find(session[:user_id])
          else
            GuestUser.new
          end
        end
      end

      set :views, 'views'
      set :root, File.expand_path('../../', __FILE__)
    end
  end
end
