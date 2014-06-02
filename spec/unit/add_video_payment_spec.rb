require "spec_helper"
require_relative "../../models/add_video_payment"
require_relative "../../purchase_tracker"

include Devcasts::Models

describe AddVideoPayment do

  let(:user) { create(:user) }
  let(:video) { create(:video, :with_revision) }
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
    context "user with credits" do
      let!(:credit_purchase) { create(:credit_purchase, credit_amount: 5, user: user) }
      let(:add_video_payment) { AddVideoPayment.new(user: user, video: video, credit_amount: 1) }

      before(:each) { add_video_payment.process }

      it "lets them buy the video" do
        expect(add_video_payment.success?).to be_true
      end

      it "saves the purchase with the correct associations" do
        expect(CreditVideoPurchase.last.video).to eq(video)
        expect(CreditVideoPurchase.last.user).to eq(user)
      end

      it "decrements the number of credits a user has" do
        expect(user.credits_remaining).to eq(4)
      end

      it "sends an email with the user's purchase" do
        Devcasts::Mailer.expects(:new).with do |*args|
          args[0] == user.email && args[2].include?(video.title)
        end.returns(Struct.new(:send).new(1))
        add_video_payment.process
      end

      it "sends a new tracker" do
        Devcasts::PurchaseTracker.expects(:new_video_purchase)
        add_video_payment.process
      end
    end

    context "user without credits" do
      let(:add_video_payment) { AddVideoPayment.new(user: user, video: video, credit_amount: 1) }

      before(:each) { add_video_payment.process }

      it "does not let the user buy the video" do
        expect(add_video_payment.success?).to be_false
      end
    end

  end
end
