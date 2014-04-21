require "spec_helper"
require_relative "../../models/user"

include Devcasts::Models

describe User do
  describe ".create_or_get_from_omniauth" do
    it "creates the user if they do not exist" do
      user = User.create_or_get_from_omniauth({
        nickname: "jackfranklin",
        name: "Jack Franklin",
        email: "jack@jackfranklin.net",
      })

      expect(user).to be_a User

    end

    it "does not create the user if they exist already" do
      user = User.new(email: 'test')
      user.save!

      expect(User.create_or_get_from_omniauth(email: 'test').id).to eq(user.id)

    end
  end

end
