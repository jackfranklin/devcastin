require_relative '../../app'
require 'spec_helper'

def app
  Devcasts::App
end

describe "Show Video Page" do
  let!(:user) { create(:user, name: 'JF') }
  let!(:video) { create(:video) }

  include Rack::Test::Methods

  def url
    "/videos/#{video.id}"
  end

  it "shows the title" do
    get url
    expect(last_response.body).to include(video.title)
  end

  context "logged in" do

    before(:each) do
      get url, {}, { 'rack.session' => { user_id: user.id } }
    end

    it "shows the logged in user" do
      expect(last_response.body).to include('JF')
    end

  end

end
