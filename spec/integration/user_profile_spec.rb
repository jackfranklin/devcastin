require 'spec_helper'

describe "User profile page" do
  let!(:user) { create(:user, name: 'JF') }
  let!(:video) { create(:video) }
  let(:url) { '/user' }

  def make_request
    get url, {}, { 'rack.session' => { user_id: user.id } }
  end

  describe "adding a credit" do
    it "increases the user's credit by 1" do
      coupon = create(:coupon)
      post '/user/add_coupon', { coupon_code: coupon.code }, {
        'rack.session' => { user_id: user.id } }
      expect(user.reload.credits_remaining).to eq(1)
    end
  end

  context "a user with videos" do
    before(:each) do
      create(:credit_purchase, credit_amount: 5, user: user)
      create(:credit_video_purchase, video: video, user: user)
    end

    it "shows the list of videos the user has purchased" do
      make_request
      expect(last_response.body).to include(video.title)
    end
  end

  context "a user with credits" do
    it "shows the user's remaining credits" do
      create(:credit_purchase, credit_amount: 5, user: user)
      make_request
      expect(last_response.body).to include('5 credits remaining')
    end

    it "doesn't pluralize for one credit" do
      create(:credit_purchase, credit_amount: 1, user: user)
      make_request
      expect(last_response.body).to include('1 credit remaining')
    end
  end

  context "a user without credits" do
    it "shows 0 remaining credits" do
      make_request
      expect(last_response.body).to include('0 credits remaining')
    end
  end
end
