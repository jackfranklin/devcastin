module Devcasts
  module Presenters
    class VideoPresenter
      def initialize(video)
        @video = video
      end
      
      def title
        if @video.free?
          "#{@video.title} (FREE)"
        else
          @video.title
        end
      end
    end
  end
end
