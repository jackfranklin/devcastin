require_relative "base_model"
require_relative "history_tracker"

module Devcasts
  module Models
    class PurchaseEvent < BaseModel
      field :user_email, type: String
      field :event_type, type: String
      field :event_id, type: String
    end
  end
end
