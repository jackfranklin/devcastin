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
    it "generates a unique code after initialisation" do
      expect(build(:coupon).code).not_to be_nil
    end
  end
end