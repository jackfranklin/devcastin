require_relative 'user'

module Devcasts
  module Models
    class CreditVideoPurchase < BaseModel

      belongs_to :user
      belongs_to :video

      field :credit_amount, type: Integer, default: 1

    end
  end
end
