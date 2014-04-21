require_relative '../../app'
require 'spec_helper'

def app
  Devcasts::App
end

describe "Index Page" do
  let!(:user) { create(:user, name: 'JF') }
  let!(:video1) { create(:video) }
  let!(:video2) { create(:video) }
  let!(:video3) { create(:video) }
  let!(:video4) { create(:video, :is_free, title: 'Free Video') }
  let!(:video5) { create(:video, title: 'Test Video') }

  include Rack::Test::Methods

  context "guest user" do
    it "should show the guest user text" do
      get '/'
      expect(last_response.body).to include('Guest User')
    end
  end

  context "logged in" do
    before(:each) do
      get '/', {}, { 'rack.session' => { user_id: user.id } }
    end

    it "shows the logged in user" do
      expect(last_response.body).to include('JF')
    end

  end

  it "shows the latest video" do
    get '/'
    expect(last_response.body).to include('Test Video')
  end

  it "marks videos as free" do
    get '/'
    expect(last_response.body).to include('Free Video (FREE)')
  end
end
