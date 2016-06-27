require "spec_helper"
require "timecop"
require_relative "../../models/video"

include Devcasts::Models

describe Video do
  describe "#latest_revision" do
    it "fetches the latest revision based on date" do
      video = create(:video)
      Timecop.freeze(Time.now - 9999) do
        video.revisions.create!(s3_url: '1')
      end
      video.revisions.create!(s3_url: '2')
      Timecop.freeze(Time.now - 8888) do
        video.revisions.create!(s3_url: '3')
      end
      expect(video.latest_revision.s3_url).to eq('2')
    end
  end

  describe "#tags" do
    it "has many tags" do
      tag1 = create(:tag)
      video = create(:video, tags: [tag1])
      expect(video.tags).to eq [tag1]
    end
  end

  describe "#free?" do
    it "is true if is_free is true" do
      expect(build(:video, is_free: true).free?).to be true
    end

    it "is false if is_free is false" do
      expect(build(:video, is_free: false).free?).to be false
    end
  end

  describe "#purchase_for_user" do
    it "finds the purchase for the current user" do
      user = build(:user)
      video = build(:video)
      video_purchase = build(:credit_video_purchase, user: user, video: video)
      expect(video.purchase_for_user(user)).to eq(video_purchase)
    end
  end

  it "is audited" do
    video = create(:video)
    tag = create(:tag)
    tag.videos << video
    tag.save!
    expect(video.history_tracks.count).to eq(2)
  end
end
