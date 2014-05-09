require_relative 'user'

module Devcasts
  module Models
    class AddCreditPayment
      attr_reader :user, :amount
      def initialize(opts)
        @user = opts.delete(:user)
        @amount = opts.delete(:amount)
        @params = opts
      end

      def process
        @customer = create_customer
        @charge = create_charge
        @purchase = create_purchase_if_success
      end

      private

      def create_purchase_if_success
        if @charge.paid
          CreditPurchase.create(
            stripe_charge_id: 1234,
            credit_amount: amount,
            user: user
          )
        end

      end

      def create_charge
        Stripe::Charge.create(
          :customer    => @customer.id,
          :amount      => 10,
          :description => "Credits for Devcast.in",
          :currency    => 'gbp'
        )
      end


      def create_customer
        Stripe::Customer.create(
          email: @params[:stripeEmail],
          card: @params[:stripeToken]
        )
      end

    end
  end
end

  # => new(amount, user)
  # => create_stripe_customer
  # => create_stripe_charge
  # => create_credit_purchase
  #     CreditPurchase.new(user, stripe_charge_id, amount)
  # => send_purchase_email

