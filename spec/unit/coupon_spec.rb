require "spec_helper"
require_relative "../../models/coupon"

include Devcasts::Models

describe Coupon do
  it "is active by default" do
    expect(build(:coupon).active).to eq(true)
  end

  it "is worth 1 credit by default" do
    expect(build(:coupon).credit_amount).to eq(1)
  end

  describe "generating a code" do
    it "generates a unique code when saved to DB" do
      expect(create(:coupon).code).not_to be_nil
    end

    it "does not allow the code to change" do
      coupon = create(:coupon)
      initial_code = coupon.code
      coupon.code = "ABC123"
      coupon.save!
      expect(coupon.code).to eq(initial_code)
    end
  end

  it "is audited" do
    user = create(:user)
    coupon = Coupon.create!(users: [user])
    user2 = create(:user)
    user2.use_coupon_code!(coupon.code)
    expect(coupon.history_tracks.count).to eq(2)
  end
end
