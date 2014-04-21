module Devcasts
  module Models
    class GuestUser
      def name
        "Guest User"
      end

      def has_video(video)
        video.free?
      end

      def videos
        []
      end
    end
  end
end
