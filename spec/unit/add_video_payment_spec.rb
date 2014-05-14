require "spec_helper"
require_relative "../../models/add_video_payment"

include Devcasts::Models

describe AddVideoPayment do

  let(:user) { build(:user) }
  let(:video) { build(:video) }
  let(:add_video_payment) do
    AddVideoPayment.new(user: user, video: video, credit_amount: 1)
  end

  def stub_charge_success
    Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(true, 4567))
  end

  def stub_charge_fail
    Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(false, 4567))
  end

  def stub_customer
    Stripe::Customer.stubs(:create).returns(Struct.new(:id).new(1234))
  end

  describe "#purchase" do
    it "creates a CreditVideoPurchase" do
      result = add_video_payment.purchase
      expect(result).to be_a(CreditVideoPurchase)
      expect(result.credit_amount).to eq(1)
      expect(result.video).to eq(video)
      expect(result.user).to eq(user)
    end
  end

  describe "#process" do
    it "invokes #purchass on the CreditVideoPurchase" do
      stub_charge_success
      stub_customer
      CreditVideoPurchase.any_instance.expects(:process)
      add_video_payment.process
    end
  end
end
