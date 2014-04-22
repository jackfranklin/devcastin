%w{user purchase video}.each do |f|
  require_relative "models/#{f}.rb"
end

Mongoid.load!("mongoid.yml", :development)
include Devcasts::Models

User.collection.drop
Video.collection.drop
Purchase.collection.drop

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

video1.save

Video.new(
  title: 'Testing Angular',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  topics: ['AngularJS', 'Testing', 'Karma'],
  published: true
).save

Video.new(
  title: 'Mocking in Ruby with Mocha',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  topics: ['Testing Ruby', 'Test Mocks', 'Mocha Gem'],
  published: true
).save

video3 = Video.new(
  title: 'Syntastic and Vim',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  is_free: true,
  topics: ['Vim', 'Vim Plugins'],
  published: true

)
video3.save

Video.new(
  title: 'Structuring Sinatra Apps',
  description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  topics: ['Designing Applications', 'Sinatra Apps'],
  published: true
).save

purchase1 = Purchase.new(charge_id: 1234)
purchase1.video = video1

purchase2 = Purchase.new(charge_id: 4567)
purchase2.video = video3

user.purchases << purchase1
user.purchases << purchase2

purchase1.save!
purchase2.save!

user.save!
