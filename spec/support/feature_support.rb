module Features
  module FeatureHelpers
    def buy_some_credits
      click_link "Purchase Credits"
      click_on "Pay with Card"
      sleep 2
      stripe_iframe = all('iframe[name=stripe_checkout_app]').last

      Capybara.within_frame stripe_iframe do
        fill_in("email", :with => "jack@jackfranklin.net")
        page.execute_script(%Q{ $('input#card_number').val('4242 4242 4242 4242'); })
        page.execute_script(%Q{ $('input#cc-exp').val('12/16'); })
        page.execute_script(%Q{ $('input#cc-csc').val('111'); })
        click_on("Pay £7.50")
      end
      sleep 5
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
