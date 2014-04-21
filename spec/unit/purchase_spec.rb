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

    describe "adding a charge" do
      it "calls stripe" do
        user = build(:user)
        video = build(:video)
        Stripe::Charge.expects(:new).returns({ "id" => "1234" })

        purchase = Purchase.new_with_charge(user: user, video: video)
        expect(purchase[:charge_id]).to eq("1234")
      end

      it "sets the charge_id" do
        user = build(:user)
        video = build(:video)
        Stripe::Charge.stubs(:new).returns({ "id" => "1234" })
        purchase = Purchase.new_with_charge(user: user, video: video)
        expect(purchase[:charge_id]).to eq("1234")
      end

    end
  end


end
