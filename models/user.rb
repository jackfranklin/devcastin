require_relative "base_model"
require_relative "purchase"

module Devcasts
  module Models
    class User < BaseModel
      field :nickname, type: String
      field :name, type: String
      field :email, type: String

      embeds_many :purchases

      def self.create_or_get_from_omniauth(opts)
        user = self.where(email: opts[:email]).first
        unless user
          user = self.new(opts)
        end
        user
      end

      def id
        self["_id"]
      end

      def videos
        self.purchases.map(&:video)
      end

      def has_video(video)
        self.purchases.any? do |purchase|
          purchase.video == video
        end
      end

    end
  end
end
