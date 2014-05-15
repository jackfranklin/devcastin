# todo: this should have an emailer in
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
          Struct.new(:charge, :success?).new(CreditPurchase.create(
            stripe_charge_id: 1234,
            credit_amount: amount,
            user: user
          ), true)
        else
          Struct.new(:charge, :success?).new(nil, false)
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
        if @user.stripe_customer_id
          Stripe::Customer.retrieve(@user.stripe_customer_id)
        else
        customer = Stripe::Customer.create(
          email: @params[:stripeEmail],
          card: @params[:stripeToken]
        )
        @user.stripe_customer_id = customer.id
        customer
        end
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

