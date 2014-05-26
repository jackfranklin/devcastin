module Devcasts
  module Models
    class Tag < BaseModel
      has_and_belongs_to_many :videos

      field :title, type: String
      field :slug, type: String
    end
  end
end
