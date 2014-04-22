require_relative 'user'
require_relative 'video'

module Devcasts
  module Models
    class Purchase < BaseModel

      belongs_to :user
      belongs_to :video

      field :charge_id, type: String

      def complete?
        !!self.charge_id
      end

    end
  end
end
