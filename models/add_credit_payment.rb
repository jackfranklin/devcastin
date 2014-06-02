require 'stripe'
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
        if @purchase.success?
          email_customer
          Devcasts::PurchaseTracker.new_credit_purchase(@user, @purchase.charge)
        end
        @purchase
      end

      private

      def create_purchase_if_success
        if @charge.paid
          Struct.new(:charge, :success?).new(CreditPurchase.create(
            stripe_charge_id: @charge.id,
            credit_amount: @amount,
            user: user
          ), true)
        else
          Struct.new(:charge, :success?).new(nil, false)
        end

      end

      def create_charge
        #todo improve the error handling here
        begin
          Stripe::Charge.create(
            :customer    => @customer.id,
            :amount      => 750,
            :description => "Credits for Devcast.in",
            :currency    => 'gbp'
          )
        rescue Exception => e
          p e
        end
      end


      def create_customer
        PaymentGateway.create_or_get_customer_for_user(
          user: @user,
          stripe_email: @params[:stripeEmail],
          stripe_token: @params[:stripeToken]
        )
      end

      def email_customer
        content = <<EML
<p>Dear #{@user.name},</p>
<p>You have succesfully purchased 5 credits for Devcastin.</p>
<p>These can be used to purchase any videos on the site.</p>
<p>If you have any questions or problems please reply to this email.</p>
<p>Thank you for your support,</p>
<p>Jack Franklin.</p>
EML
        Devcasts::Mailer.new(@user.email, 'Credit Purchase from Devcast.in', content).send
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

