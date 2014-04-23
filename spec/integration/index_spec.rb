require 'spec_helper'
require_relative '../../app'

def app
  Devcasts::App.env = :test
  Devcasts::App
end

describe "Index Page" do
  let!(:user) { create(:user, name: 'JF') }

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
    create(:video, title: 'Test Video')
    get '/'
    expect(last_response.body).to include('Test Video')
  end
end
