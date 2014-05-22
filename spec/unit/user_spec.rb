require "spec_helper"
require_relative "../../models/user"

include Devcasts::Models

describe User do
  describe ".create_or_get_from_omniauth" do
    it "creates the user if they do not exist" do
      user = User.create_or_get_from_omniauth({
        nickname: "jackfranklin",
        name: "Jack Franklin",
        email: "jack@jackfranklin.net",
      })

      expect(user).to be_a User
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
      expect(user.has_video?(video)).to be_true
    end

    it "is true if the video is free" do
      user = build(:user)
      video = build(:video, is_free: true)
      expect(user.has_video?(video)).to be_true
    end

    it "is false if the user has not purchased the video" do
      user = build(:user)
      video = build(:video)
      expect(user.has_video?(video)).to be_false
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
end
