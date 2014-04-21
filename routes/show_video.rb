module Devcasts
  module Routes
    class ShowVideo < Base
      get '/videos/:id' do
        @video = VideoPresenter.new(Video.find(params[:id]))
        erb :show_video
      end
    end
  end
end
