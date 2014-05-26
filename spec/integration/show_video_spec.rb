require 'spec_helper'

describe "Show Video Page" do
  let!(:user) { create(:user, name: 'JF') }
  let(:tag1) { create(:tag) }
  let(:tag2) { create(:tag) }
  let!(:video) { create(:video, tags: [tag1, tag2]) }

  def url
    "/videos/#{video.id}"
  end

  it "shows the title" do
    get url
    expect(last_response.body).to include(video.title)
  end

  it "shows the video tags" do
    get url
    expect(last_response.body).to include(tag1.title)
    expect(last_response.body).to include(tag2.title)
  end

  context "logged in but not purchased" do

    before(:each) do
      get url, {}, { 'rack.session' => { user_id: user.id } }
    end

    it "shows the logged in user" do
      expect(last_response.body).to include('JF')
    end

    it "shows the purchase link" do
      expect(last_response.body).to include('Purchase (1 credit)')
    end
  end

  context "logged in and purchased", :type => :feature do
    let!(:purchase) { create(:credit_video_purchase, video: video, user: user) }
    it "shows the video S3 URL" do
      get url, {}, { 'rack.session' => { user_id: user.id } }
      expect(last_response.body).to include(video.hour_s3_url)
    end
  end
end
