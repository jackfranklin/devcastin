module Devcasts
  module Models
    autoload :BaseModel, 'models/base_model'
    autoload :User, 'models/user'
    autoload :Video, 'models/video'
    autoload :GuestUser, 'models/guest_user'
    autoload :EarlyAccess, 'models/early_access'
    autoload :CreditPurchase, 'models/credit_purchase'
    autoload :CreditVideoPurchase, 'models/credit_video_purchase'
    autoload :AddCreditPayment, 'models/add_credit_payment'
    autoload :PaymentGateway, 'models/payment_gateway'
    autoload :AddVideoPayment, 'models/add_video_payment'
  end
end
