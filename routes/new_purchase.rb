require 'json'

module Devcasts
  module Routes
    class NewPurchase < Base
      error Stripe::CardError do
        'there was a card error'
      end

      get '/purchase/:video_id' do
        unless signed_in?
          redirect "/auth/github"
        end

        @video = Video.find(params[:video_id])

        if current_user.has_video?(@video)
          redirect "/videos/#{@video.id}"
        end


        erb :new_purchase
      end

      post '/purchase/:video_id' do
        video = Video.find(params[:video_id])
        customer = Stripe::Customer.create(
          :email => params[:stripeEmail],
          :card  => params[:stripeToken]
        )

        charge = Stripe::Charge.create(
          :customer    => customer.id,
          :amount      => 300,
          :description => "Purchase of '#{video.title} from Devcast.in'",
          :currency    => 'gbp'
        )

        if charge.paid
          purchase = Purchase.new(user: current_user, video: video)
          purchase.charge_id = charge.id
          purchase.save
          redirect "/purchase/confirmed/#{video.id}"
        end
      end

      get '/purchase/confirmed/:video_id' do
        @video = Video.find(params[:video_id])
        erb :confirmed_purchase
      end
    end
  end
end
