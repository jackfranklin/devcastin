require "spec_helper"
require_relative "../../models/video"

include Devcasts::Models

describe Video do
  describe "#free?" do
    it "is true if is_free is true" do
      expect(build(:video, is_free: true).free?).to be_true
    end

    it "is false if is_free is false" do
      expect(build(:video, is_free: false).free?).to be_false
    end
  end

  describe "#purchase_for_user" do
    it "finds the purchase for the current user" do
      user = build(:user)
      video = build(:video)
      credit_purchase = build(:credit_purchase, credit_amount: 5, user: user)
      video_purchase = build(:credit_video_purchase, user: user, video: video)
      expect(video.purchase_for_user(user)).to eq(video_purchase)
    end
  end
end
