module Devcasts
  module Routes
    class PurchaseCredits < Base
      get '/purchase_credits' do
        erb :purchase_credits
      end

      post '/purchase_credits' do
        unless signed_in?
          redirect "/"
        end

        payment = AddCreditPayment.new(params.merge(
          user: current_user,
          amount: 5
        )).process

        if payment.success?
          redirect '/purchase_credits/confirmed'
        else
          redirect '/purchase_credits/failed'
        end
      end

      get '/purchase_credits/confirmed' do
        erb :purchase_credits_confirmed
      end
    end
  end
end
