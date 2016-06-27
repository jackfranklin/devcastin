require_relative "base_model"

module Devcasts
  module Models
    class Coupon < BaseModel
      include Mongoid::History::Trackable

      field :code, type: String
      field :active, type: Boolean, default: true
      field :credit_amount, type: Integer, default: 1
      attr_readonly :code

      scope :active, -> { where(active: true) }

      has_and_belongs_to_many :users

      track_history :on => :all,
                    :version_field => :version,
                    :track_create  => true,
                    :track_update  => true,
                    :track_destroy => true

      before_create do |coupon|
        coupon.code = ('A'..'Z').to_a.shuffle[0,8].join
      end
    end
  end
end
