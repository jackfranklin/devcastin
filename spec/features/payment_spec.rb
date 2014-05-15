require 'spec_helper'

include Devcasts::Models
describe "Buying some credits", :type => :feature do

  let!(:video) { create(:video, title: 'Test Video') }

  before(:each) do
    User.any_instance.stubs(:stripe_customer_id).returns("cus_42bqWQ3tG2v2aW")
    visit "/"
    click_link "Log In / Sign Up"
  end

  describe "buying some credits", :js => true do
    it "adds credits to the user" do
      click_link "Purchase Credits"
      click_on "Pay with Card"
      within_frame 'stripe_checkout_app' do
        fill_in("email", :with => "jack@jackfranklin.net")
        fill_in("card_number", :with => "4242 4242 4242 4242")
        fill_in("cc-exp", :with => "03/15")
        fill_in("cc-csc", :with => "111")
        click_on("Pay £7.50")
      end
      sleep 2
      expect(page).to have_content 'Payment went through!'
      expect(User.last.credits_remaining).to eq(5)
      expect(CreditPurchase.last.user).to eq(User.last)
    end

  end

end
