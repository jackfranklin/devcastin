require 'factory_girl'
require_relative '../models/user'
require_relative '../models/purchase'
require_relative '../models/video'

FactoryGirl.define do
  factory :user, class: Devcasts::Models::User do
    nickname 'jackfranklin'
    name 'Jack Franklin'
    email 'test@test.com'
  end

  factory :purchase, class: Devcasts::Models::Purchase do
    sequence :charge_id do |n|
      "12#{n}#{n}ABC"
    end
  end

  factory :video, class: Devcasts::Models::Video do
    sequence(:title) { |n| "Video #{n}" }
    description 'lorem ipsum'
    s3_url 'someurl.com'
  end

end
