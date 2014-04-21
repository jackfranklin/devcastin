require_relative 'purchase'
module Devcasts
  module Models
    class Video < BaseModel

      belongs_to :purchase

      field :title, type: String
      field :description, type: String
      field :s3_url, type: String
      field :is_free, type: Boolean, default: false

      def free?
        self.is_free
      end

    end
  end
end
