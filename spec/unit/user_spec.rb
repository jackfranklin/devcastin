require "spec_helper"
require "timecop"
require_relative "../../models/user"
require_relative "../../models/history_tracker"

include Devcasts::Models

describe User do

  describe "last_active field" do
    it "is initially set to the creation time" do
      user = nil
      Timecop.freeze(current_time = Time.now) { user = build(:user) }
      expect(user.last_active).to eq(current_time)
    end

    describe "#update_last_active_date!" do
      it "updates last_active field to Time.now" do
        user = build(:user)
        Timecop.freeze(last_active_time = Time.now) do
          user.update_last_active_date!
        end
        expect(user.last_active).to eq(last_active_time)
      end
    end
  end

  describe ".create_or_get_from_omniauth" do
    let(:user_info) do
      { nickname: "jackfranklin",
        name: "Jack Franklin",
        email: "jack@jackfranklin.net" }
    end

    it "creates the user if they do not exist" do
      user = User.create_or_get_from_omniauth(user_info)
      expect(user).to be_a User
    end

    it "persists to the DB" do
      User.create_or_get_from_omniauth(user_info)
      expect(User.count).to eq(1)
    end

    it "does not create the user if they exist already" do
      user = create(:user, email: 'test')

      expect(User.create_or_get_from_omniauth(email: 'test').id).to eq(user.id)
    end
  end

  describe "#name" do
    it "returns the name if it exists" do
      user = create(:user, name: 'jf')
      expect(user.name).to eq('jf')
    end

    it "returns the nickname if there is no name" do
      user = create(:user, name: nil, nickname: 'jf')
      expect(user.name).to eq('jf')
    end
  end

  describe "#videos" do
    it "returns a list of videos the user has purchased" do
      user = build(:user)
      video = build(:video)
      video_purchase = build(:credit_video_purchase, user: user, video: video)

      expect(user.videos).to include(video)
    end
  end

  describe "#has_video?" do
    it "is true if the user has purchased the video" do
      user = build(:user)
      video = build(:video)
      video_purchase = build(:credit_video_purchase, user: user, video: video)
      expect(user.has_video?(video)).to be true
    end

    it "is true if the video is free" do
      user = build(:user)
      video = build(:video, is_free: true)
      expect(user.has_video?(video)).to be true
    end

    it "is false if the user has not purchased the video" do
      user = build(:user)
      video = build(:video)
      expect(user.has_video?(video)).to be false
    end
  end

  describe "#use_coupon_code!" do
    it "applies the extra credit to the user" do
      coupon = create(:coupon)
      user = create(:user)
      user.use_coupon_code!(coupon.code)
      expect(user.credits_remaining).to eq(1)
    end

    it "does not work for inactive coupons" do
      coupon = create(:coupon, active: false)
      user = create(:user)
      user.use_coupon_code!(coupon.code)
      expect(user.credits_remaining).to eq(0)
    end

    it "does not let the same coupon be applied twice" do
      coupon = create(:coupon)
      user = create(:user)
      user.use_coupon_code!(coupon.code)
      user.use_coupon_code!(coupon.code)
      expect(user.credits_remaining).to eq(1)
    end

    it "does not let the user use a made up code" do
      user = create(:user)
      user.use_coupon_code!("ABCNOTAREALCODE")
      expect(user.credits_remaining).to eq(0)
    end
  end

  describe "#credits_remaining" do
    it "is 0 if there are no purchases" do
      user = build(:user)
      expect(user.credits_remaining).to eq(0)
    end

    it "shows the amount purchased if there are no video purchases" do
      user = build(:user)
      credit_purchase = build(:credit_purchase, credit_amount: 5, user: user)
      expect(user.credits_remaining).to eq(5)
    end

    it "takes into account video purchases" do
      user = build(:user)
      credit_purchase = build(:credit_purchase, credit_amount: 5, user: user)
      video_purchase = build(:credit_video_purchase,
                             user: user, video: build(:video))
      expect(user.credits_remaining).to eq(4)
    end
  end

  describe "auditing" do
    it "is audited" do
      user = User.create!(nickname: 'jackfranklin', email: 'jack@jackfranklin.net')
      user.update_attributes!(nickname: 'jack')
      modifications = user.history_tracks.last.modified
      expect(modifications).to eq({ 'nickname' => 'jack' })
    end
  end
end
