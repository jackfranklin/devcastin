module Devcasts
  module Routes
    class Index < Base
      # error Models::NotFound do
      #   error 404
      # end
      get '/' do
        @latest_videos = Video.all.desc('_id').limit(5)
        erb :index
      end
    end
  end
end
