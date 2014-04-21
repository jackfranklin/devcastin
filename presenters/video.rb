module Devcasts
  module Presenters
    class VideoPresenter
      extend Forwardable

      def_delegators :@video, :description, :s3_url, :free?

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
