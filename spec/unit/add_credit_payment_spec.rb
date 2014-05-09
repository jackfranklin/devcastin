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
    it "adds the user's credit" do
      stub_charge_success
      stub_customer

      AddCreditPayment.new(user, 10).process
      expect(user.credits).to eq(10)
    end

  end
end

