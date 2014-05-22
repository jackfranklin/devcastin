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
        sum = Proc.new { |x, y| x + y }
        credit_amounts = self.credit_purchases.map(&:credit_amount)
        total_credits = credit_amounts.reduce(&sum) || 0
        spent_amounts = self.credit_video_purchases.map(&:credit_amount)
        total_spent = spent_amounts.reduce(&sum) || 0
        total_credits - total_spent
      end
    end
  end
end
