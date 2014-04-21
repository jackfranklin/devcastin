module Devcasts
  module Presenters
    class VideoPresenter
      extend Forwardable

      def_delegators :@video, :description, :s3_url, :free?, :id

      def initialize(video)
        @video = video
      end

      def video
        @video
      end

      def title
        if @video.free?
          "#{@video.title} (FREE)"
        else
          @video.title
        end
      end

      def path
        "/videos/#{self.id}"
      end
    end
  end
end
