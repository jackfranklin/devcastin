require 'spec_helper'

describe "New Purchase Page" do
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
end
