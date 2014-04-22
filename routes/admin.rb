module Devcasts
  module Routes
    class Admin < Base
      before do
        pass if current_user.name == 'Jack Franklin'
        redirect "/"
      end

      get '/admin' do
        @videos = Video.all

        erb :admin_index
      end

      get '/admin/make_free/:video_id' do
        video = Video.find(params[:video_id])
        video.is_free = true
        video.save
        redirect "/admin"
      end

      get '/admin/purchases/:video_id' do
        @video = Video.find(params[:video_id])
        erb :admin_video_purchases
      end

      get '/admin/purchase/:purchase_id' do
        @purchase = Purchase.find(params[:purchase_id])
        @charge = Stripe::Charge.retrieve(@purchase.charge_id)
        erb :admin_single_purchase
      end
    end

  end
end
