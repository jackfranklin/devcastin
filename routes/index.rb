module Devcasts
  module Routes
    class Index < Base
      # error Models::NotFound do
      #   error 404
      # end
      get '/' do
        erb :index
      end
    end
  end
end
