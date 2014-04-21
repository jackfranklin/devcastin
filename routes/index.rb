module Devcasts
  module Routes
    class Index < Sinatra::Application
      # error Models::NotFound do
      #   error 404
      # end
      set :views, 'views'
      set :root, File.expand_path('../../', __FILE__)

      get '/' do
        erb :index
      end
    end
  end
end
