require_relative "base_model"

module Devcasts
  module Models
    class Coupon < BaseModel
      field :code, type: String
      field :active, type: Boolean, default: true

      scope :active, where(active: true)

      has_and_belongs_to_many :users

      after_initialize do |coupon|
        coupon.code = ('A'..'Z').to_a.shuffle[0,8].join
      end
    end
  end
end
