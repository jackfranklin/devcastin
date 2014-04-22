module Devcasts
  module Routes
    class About < Base
      get '/about' do
        erb :about
      end
    end
  end
end
