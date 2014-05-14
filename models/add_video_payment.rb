# AddVideoPayment
#   => new(video, user, amount)
#   => purchase
#     CreditVideoPurchase.new(user, video, amount)
#   => send_purchase_email


module Devcasts
  module Models
    class AddVideoPayment
      def initialize(opts)
        @video = opts.fetch(:video)
        @user = opts.fetch(:user)
        @credit_amount = opts.fetch(:credit_amount)
      end

      def purchase
        @purchase ||= CreditVideoPurchase.new(
          video: @video,
          user: @user,
          credit_amount: @credit_amount
        )
      end

      def process
        # create stripe payment and customer
        # replicate add_credit_payment flow
        # send an email
        purchase_result = purchase.process
        if purchase_result.success?

        end
      end
    end
  end
end
