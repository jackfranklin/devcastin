%w{user video tag coupon credit_purchase credit_video_purchase revision}.each do |f|
  require_relative "models/#{f}.rb"
end

Mongoid.load!("mongoid.yml", :development)
include Devcasts::Models

User.collection.drop
Video.collection.drop
CreditPurchase.collection.drop
CreditVideoPurchase.collection.drop
Tag.collection.drop

user = User.create_or_get_from_omniauth(
  nickname: 'jackfranklin',
  name: 'Jack Franklin',
  email: 'jack@jackfranklin.net'
)


video1 = Video.new(
  title: 'Introduction to ES6',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  topics: ['ES6', 'JavaScript'],
  published: true
)

video1.save!

tag = Tag.new(title: 'Vim', slug: 'vim')
tag.save!

Video.create!(
  title: 'Testing Angular',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  topics: ['AngularJS', 'Testing', 'Karma'],
  published: true
)

Video.create!(
  title: 'Mocking in Ruby with Mocha',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  topics: ['Testing Ruby', 'Test Mocks', 'Mocha Gem'],
  published: true
)

Video.create!(
  title: 'Syntastic and Vim',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  is_free: true,
  topics: ['Vim', 'Vim Plugins'],
  tags: [tag],
  published: true

)

Video.create!(
  title: 'Structuring Sinatra Apps',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  topics: ['Designing Applications', 'Sinatra Apps'],
  published: true
)

CreditPurchase.create!(user: user, credit_amount: 5, stripe_charge_id: "1234ABC")
CreditVideoPurchase.create!(user: user, video: video1)
2.times { Coupon.create! }
user.save!
