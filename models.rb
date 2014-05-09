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
  end
end
