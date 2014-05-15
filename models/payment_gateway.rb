module Devcasts
  module Models
    class PaymentGateway
      def self.create_or_get_customer_for_user(opts)
        user = opts.fetch(:user)
        email = opts.fetch(:stripe_email)
        tok = opts.fetch(:stripe_token)

        if user.stripe_customer_id
          Stripe::Customer.retrieve(user.stripe_customer_id)
        else
          customer = Stripe::Customer.create(
            email: email,
            card: tok
          )
          user.stripe_customer_id = customer.id
          user.save
          customer
        end
      end
    end
  end
end
