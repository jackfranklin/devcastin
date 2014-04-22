require "spec_helper"
require "stripe"
require_relative "../../models/purchase"

include Devcasts::Models

describe Purchase do
  describe "creating a new purchase" do
    it "is not completed without a charge_id" do
      purchase = build(:purchase, charge_id: nil)
      expect(purchase.complete?).to be_false
    end

    it "is completed with a charge_id" do
      purchase = build(:purchase, charge_id: "1234")
      expect(purchase.complete?).to be_true
    end

  end
end
