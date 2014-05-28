require_relative "base_model"

module Devcasts
  module Models
    class User < BaseModel
      field :nickname, type: String
      field :name, type: String
      field :email, type: String
      field :stripe_customer_id, type: String

      validates :nickname, uniqueness: true

      has_many :credit_purchases
      has_many :credit_video_purchases
      has_and_belongs_to_many :coupons

      def self.create_or_get_from_omniauth(opts)
        user = self.where(email: opts[:email]).first
        unless user
          user = self.new(opts)
        end
        user
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
