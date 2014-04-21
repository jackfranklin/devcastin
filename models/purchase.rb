module Devcasts
  module Models
    class Purchase < BaseModel

      embedded_in :user
      embeds_one :video

    end
  end
end
