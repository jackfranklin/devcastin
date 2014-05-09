require "spec_helper"
require_relative "../../models/add_credit_payment"

include Devcasts::Models

describe AddCreditPayment do
  def stub_charge_success
    Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(true, 4567))
  end

  def stub_customer
    Stripe::Customer.stubs(:create).returns(Struct.new(:id).new(1234))
  end

  let(:user) { build(:user) }
  describe "creating a new payment" do
    it "does not add credit if payment fails" do
      Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(false, 4567))
      stub_customer
      AddCreditPayment.new(
        user: user,
        amount: 10
      ).process
      expect(user.credits_remaining).to eq(0)
    end

    it "creates a stripe customer" do
      Stripe::Customer.expects(:create).returns(Struct.new(:id).new(1234))
      stub_charge_success
      AddCreditPayment.new(
        user: user,
        amount: 10
      ).process
    end

    it "creates a stripe charge" do
      Stripe::Charge.expects(:create).returns(Struct.new(:paid, :id).new(true, 4567))
      stub_customer
      AddCreditPayment.new(
        user: user,
        amount: 10
      ).process
    end

    it "adds the user's credit" do
      stub_charge_success
      stub_customer

      AddCreditPayment.new(
        user: user,
        amount: 10
      ).process

      expect(user.credits_remaining).to eq(10)
    end

  end
end

