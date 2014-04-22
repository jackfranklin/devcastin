require_relative "base_model"
require_relative "purchase"

module Devcasts
  module Models
    class EarlyAccess < BaseModel
      field :email, type: String
      validates_uniqueness_of :email
      validates_presence_of :email
      validates_format_of :email, with: /^\S+@\S+\.\S+$/
    end
  end
end

