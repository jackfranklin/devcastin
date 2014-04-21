require_relative 'user'
require_relative 'video'

module Devcasts
  module Models
    class Purchase < BaseModel

      embedded_in :user
      embeds_one :video

      field :charge_id, type: String

      def self.new_with_charge(opts)
        user = opts[:user]
        purchase = self.new({
          video: opts[:video]
        })
        user.purchases << purchase
        user.save

        stripe_charge = Stripe::Charge.new

        purchase.charge_id = stripe_charge["id"]
        purchase
      end

      def complete?
        !!self.charge_id
      end

    end
  end
end
