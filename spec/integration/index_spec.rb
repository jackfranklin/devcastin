require 'spec_helper'

describe "Index Page" do
  let!(:user) { create(:user, name: 'JF') }
  before(:all) { create(:video, title: 'Test Video') }

  context "guest user" do
    it "should show the guest user text" do
      get '/'
      expect(last_response.body).to include('Guest User')
    end

    it "shows the latest video" do
      get '/'
      expect(last_response.body).to include('Test Video')
    end
  end

  context "logged in" do
    before(:each) do
      get '/', {}, { 'rack.session' => { user_id: user.id } }
    end

    it "shows the logged in user" do
      expect(last_response.body).to include('JF')
    end

    it "shows the latest video" do
      expect(last_response.body).to include('Test Video')
    end
  end

end
