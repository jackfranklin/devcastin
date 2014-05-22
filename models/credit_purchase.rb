require_relative 'user'

module Devcasts
  module Models
    class CreditPurchase < BaseModel

      belongs_to :user

      field :stripe_charge_id, type: String
      field :credit_amount, type: Integer

    end
  end
end
