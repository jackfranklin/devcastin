require "spec_helper"
require_relative "../../models/guest_user"

include Devcasts::Models

describe GuestUser do
  let(:user) { build(:guest_user) }

  it "has no videos" do
    expect(user.videos).to eq([])
  end

  it "only has access to free videos" do
    video = build(:video, :is_free)
    expect(user.has_video(video)).to be_true
  end

  it "doesnt have access to paid videos" do
    video = build(:video, :is_paid)
    expect(user.has_video(video)).to be_false
  end

end
