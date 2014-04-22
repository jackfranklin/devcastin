require_relative '../../app'
require 'spec_helper'

def app
  Devcasts::App
end

describe "New Purchase Page" do
  include Rack::Test::Methods


  let!(:video) { create(:video) }
  let(:url) { "/purchase/#{video.id}" }

  context "Given a guest user" do
    it "redirects to the Oauth page" do
      get url
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq("http://example.org/auth/github")
    end
  end

  context "Given a user who has purchased the video" do
    let!(:user) { create(:user) }
    let!(:purchase) { create(:purchase, user: user, video: video) }

    it "redirects to the video" do
      get url, {}, { 'rack.session' => { user_id: user.id } }
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq("http://example.org/videos/#{video.id}")
    end
  end

end
