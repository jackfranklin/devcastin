module Devcasts
  module Models
    class Video < BaseModel
      include Mongoid::History::Trackable

      has_many :credit_video_purchases
      has_and_belongs_to_many :tags

      validates :title, uniqueness: true

      field :title, type: String
      field :description, type: String
      field :s3_url, type: String
      field :is_free, type: Boolean, default: false
      field :topics, type: Array, default: []
      field :published, type: Boolean, default: false

      default_scope where(published: true)

      track_history :on => :all,
                    :version_field => :version,
                    :track_create  => true,
                    :track_update  => true,
                    :track_destroy => true

      def free?
        self.is_free
      end

      def purchase_for_user(user)
        self.credit_video_purchases.select { |p| p.user = user }.first
      end

      def hour_s3_url
        s3 = AWS::S3.new
        s3_filename = Pathname.new(s3_url).split.last.to_s

        bucket = s3.buckets['jf-devcasts']
        vid = bucket.objects[s3_filename]
        vid.url_for(:read, :expires => 60).to_s
      end
    end
  end
end
