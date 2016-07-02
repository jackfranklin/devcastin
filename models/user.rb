require_relative "base_model"
require_relative "history_tracker"

module Devcasts
  module Models
    class User < BaseModel
      include Mongoid::History::Trackable

      field :nickname, type: String
      field :name, type: String
      field :email, type: String
      field :stripe_customer_id, type: String
      field :last_active, type: Time, default: -> { Time.now }

      track_history :on => :all,
                    :version_field => :version,
                    :track_create  => true,
                    :track_update  => true,
                    :track_destroy => true


      validates :nickname, uniqueness: true

      has_many :credit_purchases
      has_many :credit_video_purchases
      has_and_belongs_to_many :coupons

      def self.create_or_get_from_omniauth(opts)
        # convert to symbols for keys
        opts = opts.each_with_object({}) do |(k, v), h|
          h[k.to_sym] = v
        end

        user = self.where(email: opts[:email]).first
        unless user
          user = self.new(opts)
        end

        user.save!
        user
      end

      def update_last_active_date!
        self.update_attributes!(last_active: Time.now)
      end

      def name
        self.attributes["name"].nil? ? self.nickname : self.attributes["name"]
      end

      def videos
        self.credit_video_purchases.map(&:video)
      end

      def has_video?(video)
        video.free? || self.videos.any? { |v| video == v }
      end

      def credits_remaining
        coupon_credits_gained + credits_purchased - credits_spent
      end

      def use_coupon_code!(code)
        self.coupons << Coupon.active.find_by(code: code)
        self.save
      rescue Mongoid::Errors::DocumentNotFound
        false
      end

      private

      def coupon_credits_gained
        self.coupons.map(&:credit_amount).reduce { |x, y| x + y } || 0
      end

      def credits_spent
        self.credit_video_purchases.map(&:credit_amount).reduce { |x, y| x + y } || 0
      end

      def credits_purchased
        self.credit_purchases.map(&:credit_amount).reduce { |x, y| x + y } || 0
      end
    end
  end
end
