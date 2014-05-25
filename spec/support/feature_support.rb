module Features
  module FeatureHelpers
    def buy_some_credits
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
    end

    def sign_in
      visit "/"
      click_link "Log In / Sign Up"
    end

    def sign_out
      click_link 'Logout'
    end
  end
end
