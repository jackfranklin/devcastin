require "spec_helper"
require_relative '../../purchase_tracker.rb'

include Devcasts::Models

describe Devcasts::PurchaseTracker do
  describe ".new_credit_purchase" do
    it "creates a new purchase event" do
      Devcasts::PurchaseTracker.new_credit_purchase(stub(:email => 'j@j.com'), stub(:id => "1234"))
      expect(PurchaseEvent.count).to eq(1)
    end

    it "sets the right fields" do
      Devcasts::PurchaseTracker.new_credit_purchase(stub(:email => 'j@j.com'), stub(:id => "1234"))
      purchase = PurchaseEvent.last
      expect(purchase.event_type).to eq('credit')
      expect(purchase.user_email).to eq('j@j.com')
      expect(purchase.event_id).to eq('1234')
    end

    it "sends an email" do
      message_content = "New Purchase: j@j.com, 'credit', 1234"
      Devcasts::Mailer.expects(:new).with('devcastin+event@gmail.com',
                                                        'New Purchase',
                                                        message_content).returns(stub(:send => true))
      Devcasts::PurchaseTracker.new_credit_purchase(stub(:email => 'j@j.com'), stub(:id => "1234"))
    end
  end
  describe ".new_video_purchase" do
    it "creates a new purchase event" do
      Devcasts::PurchaseTracker.new_video_purchase(stub(:email => 'j@j.com'), stub(:id => "1234"))
      expect(PurchaseEvent.count).to eq(1)
    end

    it "sets the right fields" do
      Devcasts::PurchaseTracker.new_video_purchase(stub(:email => 'j@j.com'), stub(:id => "1234"))
      purchase = PurchaseEvent.last
      expect(purchase.event_type).to eq('video')
      expect(purchase.user_email).to eq('j@j.com')
      expect(purchase.event_id).to eq('1234')
    end

    it "sends an email" do
      message_content = "New Purchase: j@j.com, 'video', 1234"
      Devcasts::Mailer.expects(:new).with('devcastin+event@gmail.com',
                                                        'New Purchase',
                                                        message_content).returns(stub(:send => true))
      Devcasts::PurchaseTracker.new_video_purchase(stub(:email => 'j@j.com'), stub(:id => "1234"))
    end
  end
end
