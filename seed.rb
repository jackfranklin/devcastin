%w{user purchase video}.each do |f|
  require_relative "models/#{f}.rb"
end

Mongoid.load!("mongoid.yml", :development)
include Devcasts::Models

user = User.create_or_get_from_omniauth(
  nickname: 'jackfranklin',
  name: 'Jack Franklin',
  email: 'jack@jackfranklin.net'
)

video1 = Video.new(
  title: 'Introduction to ES6',
  description: 'lorem ipsum',
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4'
)

video1.save

Video.new(
  title: 'Testing Angular',
  description: 'lorem ipsum',
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4'
).save

Video.new(
  title: 'Mocking in Ruby with Mocha',
  description: 'lorem ipsum',
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4'
).save

video3 = Video.new(
  title: 'Syntastic and Vim',
  description: 'lorem ipsum',
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4',
  is_free: true
)
video3.save

Video.new(
  title: 'Structuring Sinatra Apps',
  description: 'lorem ipsum',
  s3_url: 'http://jf-devcasts.s3.amazonaws.com/ScreenFlow.mp4'
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
