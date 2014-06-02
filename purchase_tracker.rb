require 'dotenv'
require_relative 'mailer'
require_relative 'models/purchase_event'

module Devcasts
  class PurchaseTracker
    def self.new_credit_purchase(user, purchase)
      Models::PurchaseEvent.create!(user_email: user.email,
                        event_type: 'credit',
                        event_id: purchase.id)

      content = "New Purchase: #{user.email}, 'credit', #{purchase.id}"
      Mailer.new('devcastin+event@gmail.com', 'New Purchase', content).send
    end

    def self.new_video_purchase(user, purchase)
      Models::PurchaseEvent.create!(user_email: user.email,
                        event_type: 'video',
                        event_id: purchase.id)

      content = "New Purchase: #{user.email}, 'video', #{purchase.id}"
      Mailer.new('devcastin+event@gmail.com', 'New Purchase', content).send
    end
  end
end
