require_relative 'purchase'
module Devcasts
  module Models
    class Video < BaseModel

      has_many :purchases

      validates :title, uniqueness: true

      field :title, type: String
      field :description, type: String
      field :s3_url, type: String
      field :is_free, type: Boolean, default: false

      def id
        self["_id"]
      end

      def free?
        self.is_free
      end

    end
  end
end
