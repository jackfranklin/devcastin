require "spec_helper"
require_relative "../../presenters/video"

include Devcasts::Presenters

describe VideoPresenter do
  let(:video) { create(:video, title: 'My Video') }

  context "Free video" do
    let(:free_video) { create(:video, :is_free, title: 'Free Video') }
    let(:presenter) { VideoPresenter.new(free_video) }
    it "shows (FREE VIDEO) in title" do
      expect(presenter.title).to eq("Free Video (FREE)")
    end
  end
end
