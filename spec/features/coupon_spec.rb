require 'spec_helper'

include Devcasts::Models

describe "Using a Coupon", :type => :feature do
  let!(:video) { create(:video, title: 'Test Video') }
  let!(:coupon) { create(:coupon) }

  it "lets the user use a coupon code" do
    sign_in
    visit '/user'
    fill_in("coupon_code", with: coupon.code)
    click_on("Go")
    expect(User.last.credits_remaining).to eq(1)
  end
end
