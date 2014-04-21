require 'factory_girl'
require_relative '../models/user'
require_relative '../models/purchase'
require_relative '../models/video'
require_relative "../models/guest_user"

FactoryGirl.define do
  factory :user, class: Devcasts::Models::User do
    sequence(:nickname) { |n| "jackfranklin#{n}" }
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

    trait :is_free do
      is_free true
    end

    trait :is_paid do
      is_free false
    end

  end

  factory :guest_user, class: Devcasts::Models::GuestUser do
  end

end
