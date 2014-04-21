require_relative 'user'
require_relative 'video'

module Devcasts
  module Models
    class Purchase < BaseModel

      embedded_in :user
      embeds_one :video

      field :charge_id, type: String

    end
  end
end
