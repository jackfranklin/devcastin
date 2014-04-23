require 'spec_helper'

include Devcasts::Models
describe "Buying a video", :type => :feature do

  let!(:video) { create(:video, title: 'Test Video') }

  before(:each) do
    visit "/"
    click_link "Log In / Sign Up"
  end

  describe "paying for a video", :js => true do
    it "takes payment with stripe" do
      click_link "Purchase (£3)"
      click_on "Pay with Card"
      within_frame 'stripe_checkout_app' do
        fill_in("email", :with => "jack@jackfranklin.net")
        fill_in("card_number", :with => "4242 4242 4242 4242")
        fill_in("cc-exp", :with => "03/15")
        fill_in("cc-csc", :with => "111")
        click_on("Pay £3.00")
      end
      sleep 2
      expect(page).to have_content 'Purchase Successful'
      expect(Purchase.last.video.id).to eq(video.id)
    end

  end

end
