module Devcasts
  module Routes
    class Admin < Base
      def redirect_if_not_admin
        unless current_user.name = 'Jack Franklin'
          redirect "/"
          return
        end
      end

      get '/admin' do
        redirect_if_not_admin

        @videos = Video.all

        erb :admin_index
      end

      get '/admin/make_free/:video_id' do
        redirect_if_not_admin

        video = Video.find(params[:video_id])
        video.is_free = true
        video.save

        redirect "/admin"
      end

      get '/admin/purchases/:video_id' do
        redirect_if_not_admin

        @video = Video.find(params[:video_id])

        erb :admin_video_purchases
      end

      get '/admin/purchase/:purchase_id' do
        redirect_if_not_admin

        @purchase = Purchase.find(params[:purchase_id])
        @charge = Stripe::Charge.retrieve(@purchase.charge_id)

        erb :admin_single_purchase
      end
    end

  end
end
