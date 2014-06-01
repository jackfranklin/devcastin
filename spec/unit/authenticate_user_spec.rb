require "spec_helper"
require_relative "../../models/authenticate_user"
require_relative "../../models/user"

include Devcasts::Models

describe AuthenticateUser do
  let(:user_info) do
    { nickname: 'jf',
      name: 'Jack',
      email: 'j@j.com' }
  end

  it "fetches or creates the user by delegating to create_or_get_from_omniauth" do
    User.expects(:create_or_get_from_omniauth).with(user_info).
      returns(stub(:update_last_active_date! => true))
    AuthenticateUser.new(user_info).process
  end

  it "returns a user instance" do
    expect(AuthenticateUser.new(user_info).process).to be_a User
  end

  it "updates the user's last_active field" do
    User.any_instance.expects(:update_last_active_date!).returns(true)
    AuthenticateUser.new(user_info).process
  end
end
