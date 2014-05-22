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

  context "the payment fails" do
    it "sets success? to false if the payment failed" do
      Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(false, 4567))
      stub_customer
      result = AddCreditPayment.new(
        user: user,
        amount: 10
      ).process
      expect(result.success?).to be_false
    end

    it "does not add credit if payment fails" do
      Stripe::Charge.stubs(:create).returns(Struct.new(:paid, :id).new(false, 4567))
      stub_customer
      AddCreditPayment.new(
        user: user,
        amount: 10
      ).process
      expect(user.credits_remaining).to eq(0)
    end

  end

  context "the payment succeeds" do
    it "adds the user's credit" do
      stub_charge_success
      stub_customer

      AddCreditPayment.new(
        user: user,
        amount: 10
      ).process

      expect(user.credits_remaining).to eq(10)
    end

    it "emails the customer" do
      Devcasts::Mailer.expects(:new).with do |*args|
        args[0] == user.email && args[1].include?('Credit Purchase')
      end.returns(Struct.new(:send).new(1))
      stub_charge_success
      stub_customer
      AddCreditPayment.new(user: user, amount: 5).process
    end

    it "returns a struct with the charge information" do
      stub_charge_success
      stub_customer

      result = AddCreditPayment.new(user: user, amount: 10).process
      expect(result.charge).to be_a(CreditPurchase)
      expect(result.success?).to be_true
    end
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

  it "adds stripe_customer_id to the user" do
    stub_charge_success
    stub_customer
    AddCreditPayment.new(
      user: user,
      amount: 10
    ).process
    expect(user.stripe_customer_id).to eq("1234")
  end

  it "calls the stripe API if a ID already exists" do
    Stripe::Customer.expects(:retrieve).
      with("1234").returns(Struct.new(:id).new("1234"))
    stub_charge_success
    stub_customer
    user.stripe_customer_id = "1234"
    AddCreditPayment.new(user: user, amount: 10).process
  end
end

