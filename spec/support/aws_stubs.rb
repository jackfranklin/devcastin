class AWSStub
  def buckets
    AWSBucketsStub.new
  end
end

class AWSBucketsStub
  def [](*args)
    AWSBucketStub.new
  end
end

class AWSBucketStub
  def objects
    AWSObjectStub.new
  end
end

class AWSObjectStub
  def [](*args)
    AWSVideoStub.new
  end
end

class AWSVideoStub
  def url_for(*args)
    'http://video.s3.com'
  end
end
