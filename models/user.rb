require_relative "base_model"
require_relative "purchase"

module Devcasts
  module Models
    class User < BaseModel
      field :nickname, type: String
      field :name, type: String
      field :email, type: String

      validates :nickname, uniqueness: true

      has_many :purchases

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
        self.purchases.map(&:video)
      end

      def has_video?(video)
        video.free? || self.purchases.any? do |purchase|
          purchase.video == video
        end
      end

    end
  end
end
