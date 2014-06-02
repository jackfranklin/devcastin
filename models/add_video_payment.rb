module Devcasts
  module Models
    class AddVideoPayment
      def initialize(opts)
        @video = opts.fetch(:video)
        @user = opts.fetch(:user)
        @success = false
        @credit_amount = opts.fetch(:credit_amount)
      end

      def purchase
        @purchase ||= CreditVideoPurchase.new(
          video: @video,
          user: @user,
          credit_amount: @credit_amount
        )
      end

      def success?
        !!@success
      end

      def process
        if @user.credits_remaining > 0
          @success = purchase.save
          content = <<EML
<p>Dear #{@user.name},</p>
<p>You have succesfully purchased "#{@video.title}". You can download the video at the following URL:</p>
<p>#{@video.hour_s3_url}</p>
<p>The above URL will expire after one hour of this email being sent. You can always get a new URL and stream the video at: http://devcast.in/videos/#{@video.id}.</p>
<p>If you have any questions or problems please reply to this email.</p>
<p>Thank you for your support,</p>
<p>Jack Franklin.</p>
EML
          Devcasts::Mailer.new(@user.email, 'Video Purchase from Devcast.in', content).send
          Devcasts::PurchaseTracker.new_video_purchase(@user, purchase)
        end
      end
    end
  end
end
