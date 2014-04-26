require "spec_helper"
require_relative "../../models/video_purchase"

include Devcasts::Models

describe VideoPurchase do
  let(:video) { create(:video) }
  let(:user) { create(:user) }

  def create_video
    VideoPurchase.new(
      video_id: video.id,
      user_id: user.id,
      stripeEmail: 'test',
      stripeToken: 'test'
    ).create
  end

  it "creates a new stripe customer" do
    Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(true, 4567))
    Stripe::Customer.expects(:create).with({
      email: 'test',
      card: 'test'
    }).returns(Struct.new(:id).new(1234))
    create_video
  end

  it "creates a stripe charge" do
    Stripe::Charge.expects(:create).with({
      customer: 1234,
      amount: 300,
      currency: 'gbp',
      description: "Purchase of '#{video.title} from Devcast.in'"
    }).returns(Struct.new(:paid, :id).new(true, 4567))

    Stripe::Customer.stubs(:create).with({
      email: 'test',
      card: 'test'
    }).returns(Struct.new(:id).new(1234))
    create_video
  end

  it "creates a purchase if payment successful" do
    Stripe::Customer.stubs(:create).returns(Struct.new(:id).new(1234))
    Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(true, 4567))
    expect(create_video).to be_a(Purchase)
    expect(create_video.video).to eq(video)
  end

  it "returns false if payment failed" do
    Stripe::Customer.stubs(:create).returns(Struct.new(:id).new(1234))
    Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(false, 4567))
    expect(create_video).to be_false
  end
end
