module Devcasts
  module Routes
    class PurchaseCredits < Base
      get '/purchase_credits' do
        erb :purchase_credits
      end
    end
  end
end
