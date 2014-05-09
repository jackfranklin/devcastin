module Devcasts
  module Models
    class AddCreditPayment
    end
  end
end

  # => new(amount, user)
  # => create_stripe_customer
  # => create_stripe_charge
  # => create_credit_purchase
  #     CreditPurchase.new(user, stripe_charge_id, amount)
  # => send_purchase_email

