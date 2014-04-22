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

          send_purchase_email(video)

          redirect "/purchase/confirmed/#{video.id}"
        end
      end

      get '/purchase/confirmed/:video_id' do
        @video = Video.find(params[:video_id])
        erb :confirmed_purchase
      end

      private

      def send_purchase_email(video)
        s3_url = get_hour_s3_url(video)
        content = <<EML
<p>Dear #{current_user.name},</p>
<p>You have succesfully purchased "#{video.title}". You can download the video at the following URL:</p>
<p>#{s3_url}</p>
<p>The above URL will expire after one hour of this email being sent. You can always get a new URL and stream the video at: http://devcasts.in/videos/#{video.id}.</p>
<p>If you have any questions or problems please reply to this email.</p>
<p>Thank you for your support,</p>
<p>Jack Franklin.</p>
EML
      puts content
      Devcasts::Mailer.new(current_user.email, 'Purchase from Devcast.in', content).send
      end
    end
  end
end
