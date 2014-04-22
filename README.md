- host videos on S3
- store videos in MongoDB
- admin area (active admin?) for user jackfranklin from github
- all authentication done via Github
- can generate an S3 URL that works for X minutes [http://docs.aws.amazon.com/AWSRubySDK/latest/frames.html]

```
bucket.objects.myobject.url_for(:read, :expires => 10*60)
```
