require 'spec_helper'

include Devcasts::Models
describe "Purchasing", :type => :feature do

  let!(:video) { create(:video, :with_revision, title: 'Test Video') }

  before(:each) do
    User.any_instance.stubs(:stripe_customer_id).returns("cus_42bqWQ3tG2v2aW")
  end

  describe "buying some credits", :js => true do
    before(:each) { sign_in }
    after(:each) { sign_out }

    it "adds credits to the user" do
      buy_some_credits
      expect(page).to have_content 'Payment went through!'
      expect(User.last.credits_remaining).to eq(5)
      expect(CreditPurchase.last.user).to eq(User.last)
    end
  end

  describe "buying a video", :js => true do
    before(:each) { sign_in }
    after(:each) { sign_out }

    it "lets the user buy the video with a credit" do
      visit "/"
      buy_some_credits
      sleep 2
      visit "/"
      click_link "Purchase (1 credit)"
      click_on "Purchase (one credit)"
      expect(page).to have_content 'Purchase Successful'
      expect(User.last.credits_remaining).to eq(4)
      expect(User.last.videos).to include(video)
    end
  end
end
