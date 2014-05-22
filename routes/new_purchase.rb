require 'json'

module Devcasts
  module Routes
    class NewPurchase < Base
      # error Stripe::CardError do
      #   'there was a card error'
      # end

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
        purchase = AddVideoPayment.new(
          video: Video.find(params[:video_id]),
          user: current_user,
          credit_amount: 1
        )

        purchase.process

        if purchase.success?
          redirect "/purchase/confirmed/#{params[:video_id]}"
        else
          # todo this
          ' went wrong '
        end
      end

      get '/purchase/confirmed/:video_id' do
        @video = Video.find(params[:video_id])
        @s3_url = @video.hour_s3_url
        erb :confirmed_purchase
      end
    end
  end
end
