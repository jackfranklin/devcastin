require "spec_helper"
require_relative "../../models/tag"

include Devcasts::Models

describe Tag do
  it "belongs to a set of videos" do
    tag = create(:tag)
    video1 = create(:video, tags: [tag])
    video2 = create(:video, tags: [tag])
    expect(tag.videos).to eq [video1, video2]
  end
end
