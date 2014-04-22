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
      purchase = build(:purchase, video: video, user: user)
      expect(video.purchase_for_user(user)).to eq(purchase)
    end
  end
end
