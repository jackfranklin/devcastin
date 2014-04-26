require 'stripe'
require_relative 'video'

module Devcasts
  module Models
    class VideoPurchase
      def initialize(params)
        @params = params
        @video_id = params[:video_id]
      end

      def create
        @customer = create_customer
        @charge = create_charge
        @purchase_success = create_purchase_if_success
      end

      private

      def user
        @user ||= User.find(@params[:user_id])
      end

      def create_purchase_if_success
        if @charge.paid
          purchase = Purchase.new(user: user, video: video)
          purchase.charge_id = @charge.id
          purchase.save
          return purchase
        else
          return false
        end
      end

      def create_charge
        Stripe::Charge.create(
          :customer    => @customer.id,
          :amount      => 300,
          :description => "Purchase of '#{video.title} from Devcast.in'",
          :currency    => 'gbp'
        )
      end


      def create_customer
        Stripe::Customer.create(
          email: @params[:stripeEmail],
          card: @params[:stripeToken]
        )
      end

      def video
        @video ||= Video.find(@video_id)
      end
    end
  end
end
