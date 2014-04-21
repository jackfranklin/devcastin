module Devcasts
  module Routes
    class Base < Sinatra::Application
      # error Models::NotFound do
      #   error 404
      # end

      include Devcasts::Models

      set :views, 'views'
      set :root, File.expand_path('../../', __FILE__)
    end
  end
end
