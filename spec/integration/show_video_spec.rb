require 'spec_helper'

describe "Show Video Page" do
  let!(:user) { create(:user, name: 'JF') }
  let!(:video) { create(:video) }

  def url
    "/videos/#{video.id}"
  end

  it "shows the title" do
    get url
    expect(last_response.body).to include(video.title)
  end

  context "logged in but not purchased" do

    before(:each) do
      get url, {}, { 'rack.session' => { user_id: user.id } }
    end

    it "shows the logged in user" do
      expect(last_response.body).to include('JF')
    end

    it "shows the purchase link" do
      expect(last_response.body).to include('Purchase (&pound;3)')
    end
  end

  context "logged in and purchased" do
    let!(:paid_user) { create(:user) }
    let!(:purchase) { create(:purchase, charge_id: 1234, video: video, user: paid_user) }

    it "shows the video" do
      get url, {}, { 'rack.session' => { user_id: paid_user.id } }
      expect(last_response.body).to include(video.s3_url)
    end
  end
end
