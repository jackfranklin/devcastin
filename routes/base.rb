module Devcasts
  module Routes
    class Base < Sinatra::Application
      # error Models::NotFound do
      #   error 404
      # end

      include Devcasts::Models

      helpers do
        def signed_in?
          !session[:user_id].nil?
        end
      end

      set :views, 'views'
      set :root, File.expand_path('../../', __FILE__)
    end
  end
end
