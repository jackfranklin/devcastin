require 'spec_helper'

describe "Archives" do
  let!(:user) { create(:user, name: 'JF') }

  def make_request
    get url, {}, { 'rack.session' => { user_id: user.id } }
  end

  context "the base archive page" do
    let(:url) { '/archives' }
    let!(:video) { create(:video) }
    let!(:video_free) { create(:video, :is_free) }
    it "shows all videos" do
      make_request
      expect(last_response.body).to include(video.title)
      expect(last_response.body).to include(video_free.title)
    end
  end

  context "the free archive page" do
    let(:url) { '/archives/free' }
    let!(:video) { create(:video) }
    let!(:video_free) { create(:video, :is_free) }
    it "shows only free videos" do
      make_request
      expect(last_response.body).not_to include(video.title)
      expect(last_response.body).to include(video_free.title)
    end
  end

  context "the tags archive page" do
    let!(:tag) { create(:tag) }
    let(:url) { "/archives/tag/#{tag.slug}" }
    let!(:video_with_tag) do
      video = create(:video)
      video.tags << tag
      video
    end
    let!(:video_without_tag) { create(:video) }
    it "shows only videos with the tag" do
      make_request
      expect(last_response.body).to include(video_with_tag.title)
      expect(last_response.body).not_to include(video_without_tag.title)
    end
  end
end
