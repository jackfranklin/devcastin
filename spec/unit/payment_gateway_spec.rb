require "spec_helper"
require_relative "../../models/payment_gateway"

include Devcasts::Models

describe PaymentGateway do

  describe ".create_or_get_customer_for_user" do
    context "user is not a customer" do
      let(:user) { build(:user) }
      it "creates one if the user does not have a customer id" do
        Stripe::Customer.expects(:create).returns(Struct.new(:id).new(1234))
        PaymentGateway.create_or_get_customer_for_user(
          user: user,
          stripe_email: 'testin',
          stripe_token: 1234
        )
        expect(user.stripe_customer_id).to eq("1234")
      end
    end

    context "user is a customer" do
      let(:user) { build(:user, stripe_customer_id: "1234") }
      it "doesn't create one if the user does not have a customer id" do
        Stripe::Customer.expects(:retrieve).returns(Struct.new(:id).new(1234))
        Stripe::Customer.expects(:create).never
        PaymentGateway.create_or_get_customer_for_user(
          user: user,
          stripe_email: 'testin',
          stripe_token: 1234
        )
      end
    end
  end
end
