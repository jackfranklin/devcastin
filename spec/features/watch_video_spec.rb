require 'spec_helper'

include Devcasts::Models

describe "Viewing videos", :type => :feature do
  let!(:video) { create(:video, :is_paid) }
  let(:user) { User.where(name: 'Jack Franklin').first }
  let(:video_path) { "/videos/#{video.id}" }

  before(:each) do
    User.any_instance.stubs(:stripe_customer_id).returns("cus_42bqWQ3tG2v2aW")
  end

  context "the user is signed in" do
    before(:each) { sign_in }
    after(:each) { sign_out }

    context "the user has not purchased the video" do
      it "shows the purchase button" do
        visit video_path
        expect(page).to have_link 'Purchase (1 credit)'
        expect(page).not_to have_link 'Download (MP4)'
      end
    end

    context "the user has purchased the video" do
      it "lets the user view a video they have purchased" do
        create(:credit_video_purchase, user: user, video: video)
        visit video_path
        expect(page).to have_link 'Download (MP4)', href: video.hour_s3_url
      end
    end
  end

  context "with a free video" do
    let!(:video) { create(:video, :is_free) }

    context "the user is signed in" do
      it "shows them the video" do
        sign_in
        visit video_path
        expect(page).to have_link 'Download (MP4)', href: video.hour_s3_url
        sign_out
      end
    end

    it "lets any user see" do
      visit video_path
      expect(page).to have_link 'Download (MP4)', href: video.hour_s3_url
    end
  end
end
