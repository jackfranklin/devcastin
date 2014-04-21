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

  describe "#id" do
    it "returns the Mongo _id" do
      user = create(:user, email: 'test')
      id = user["_id"]

      expect(user.id).to equal(id)
    end
  end

  describe "#videos" do
    it "returns a list of videos the user has purchased" do
      user = build(:user)
      purchase1 = build(:purchase, user: user)
      purchase2 = build(:purchase, user: user)
      videos = [build(:video, purchase: purchase1),
                build(:video, purchase: purchase2)]

      user_videos = user.videos
      expect(user_videos[0]).to eq(videos[0])
      expect(user_videos[1]).to eq(videos[1])
    end
  end

  describe "#has_video" do
    it "is true if the user has purchased the video" do
      user = build(:user)
      purchase = build(:purchase, user: user)
      video = build(:video, purchase: purchase)
      expect(user.has_video(video)).to be_true
    end

    it "is false if the user has not purchased the video" do
      user = build(:user)
      user2 = build(:user)
      purchase = build(:purchase, user: user2)
      video = build(:video, purchase: purchase)
      expect(user.has_video(video)).to be_false
    end
  end
end
