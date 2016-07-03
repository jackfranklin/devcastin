## Devcast.in

[www.devcast.in](http://www.devcast.in).

A Ruby application built for when I was planning to release screencasts for sale, which may still happen!

Uses:

- MongoDB for database.
- Stripe for payments.
- Amazon S3 for video storage.
- Sinatra for the application.
- OmniAuth and GitHub for user authentication and logging in.

## Tests

The `spec/feature/payments_spec.rb` require the `STRIPE_TEST_SECRET` and `STRIPE_TEST_PUBLISH` keys to be present in `.env`. Unfortunately the feature tests do currently make a request to the Stripe API; it would be nice to look into stubbing this.

Capybara specs need __Firefox 44__.

Specs can be run with `rspec`.

## Future Work

- Swap out MongoDB for Postgres (at the time of writing this I was working with Mongo at lot, I'd rather use Postgres now!).
- Mock Stripe in the feature tests.

## Thoughts

In hindsight I should probably have used Ruby on Rails for this; the amount of time I've spent configuring things like Capybara + Sinatra + RSpec when most of it comes out of the box with Rails means that I could have developed more quickly!



### Notes
- host videos on S3
- store videos in MongoDB
- admin area (active admin?) for user jackfranklin from github
- all authentication done via Github
- can generate an S3 URL that works for X minutes [http://docs.aws.amazon.com/AWSRubySDK/latest/frames.html]

```
bucket.objects.myobject.url_for(:read, :expires => 10*60)
```
