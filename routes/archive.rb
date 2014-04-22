module Devcasts
  module Routes
    class Archive < Base
      get '/archives' do
        @videos = Video.all
        erb :archive
      end
    end
  end
end
