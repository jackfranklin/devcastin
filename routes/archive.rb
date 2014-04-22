module Devcasts
  module Routes
    class Archive < Base
      get '/archives' do
        @videos = Video.all
        erb :archive
      end

      get '/archives/free' do
        @videos = Video.where(is_free: true)
        erb :archive
      end
    end
  end
end
