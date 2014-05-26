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

      get '/archives/tag/:tag' do
        tag = Tag.find_by(slug: params[:tag])
        @videos = tag.videos
        erb :archive
      end
    end
  end
end
