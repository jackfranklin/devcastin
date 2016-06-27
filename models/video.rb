module Devcasts
  module Models
    class Video < BaseModel
      include Mongoid::History::Trackable

      embeds_many :revisions
      has_many :credit_video_purchases
      has_and_belongs_to_many :tags

      validates :title, uniqueness: true

      field :title, type: String
      field :description, type: String
      field :is_free, type: Boolean, default: false
      field :topics, type: Array, default: []
      field :published, type: Boolean, default: false

      default_scope -> { where(published: true) }

      track_history :on => :all,
                    :version_field => :version,
                    :track_create  => true,
                    :track_update  => true,
                    :track_destroy => true

      def free?
        self.is_free
      end

      def latest_revision
        revisions.order_by(:created_at.desc).first
      end

      def purchase_for_user(user)
        self.credit_video_purchases.select { |p| p.user = user }.first
      end

      def hour_s3_url
        latest_revision.hour_s3_url
      end
    end
  end
end
