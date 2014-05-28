require 'factory_girl'
require_relative '../models/user'
require_relative '../models/video'
require_relative "../models/guest_user"
require_relative "../models/credit_purchase"
require_relative "../models/credit_video_purchase"
require_relative "../models/tag"
require_relative "../models/coupon"

FactoryGirl.define do
  factory :user, class: Devcasts::Models::User do
    sequence(:nickname) { |n| "jackfranklin#{n}" }
    name 'Jack Franklin'
    email 'test@test.com'
  end

  factory :credit_purchase, class: Devcasts::Models::CreditPurchase do
    sequence(:stripe_charge_id) { |n| "1234#{n}" }
    credit_amount 1
  end

  factory :credit_video_purchase, class: Devcasts::Models::CreditVideoPurchase do
  end

  factory :video, class: Devcasts::Models::Video do
    sequence(:title) { |n| "Video #{n}" }
    description 'lorem ipsum'
    s3_url 'someurl.com'
    published true

    trait :is_free do
      is_free true
    end

    trait :is_paid do
      is_free false
    end

    trait :unpublished do
      published false
    end

  end

  factory :guest_user, class: Devcasts::Models::GuestUser do
  end

  factory :coupon, class: Devcasts::Models::Coupon

  factory :tag, class: Devcasts::Models::Tag do
    sequence(:title) { |n| "Tag #{n}" }
    sequence(:slug) { |n| "tag-#{n}" }
  end

end
