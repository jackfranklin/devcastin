require "timecop"
require 'spec_helper'

include Devcasts::Models

describe "Authentication" do
  let!(:video) { create(:video) }
  it "updates the last_active field" do
    sign_in_through_github
    sign_out
    Timecop.freeze(last_active = Time.now) do
      sign_in_through_github
    end
    # have to to_s because the objects don't match
    expect(User.last.last_active.to_s).to eq(last_active.to_s)
  end

  def sign_out
    get '/logout'
    follow_redirect!
  end

  def sign_in_through_github
    get '/auth/github'
    follow_redirect!
    follow_redirect!
  end
end
