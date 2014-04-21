module Devcasts
  module Models
    class Video < BaseModel

      embedded_in :purchase

      field :title, type: String
      field :description, type: String
      field :s3_url, type: String

    end
  end
end
