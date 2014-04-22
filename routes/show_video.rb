require 'pathname'

module Devcasts
  module Routes
    class ShowVideo < Base
      get '/videos/:id' do
        @video = Video.find(params[:id])
        @s3_url = get_hour_s3_url(@video)
        erb :show_video
      end
    end
  end
end
