module Devcasts
  module Models
    class Revision < BaseModel
      embedded_in :video
      field :s3_url, type: String

      validates_uniqueness_of :s3_url

      def hour_s3_url
        s3 = AWS::S3.new
        s3_filename = Pathname.new(s3_url).split.last.to_s

        bucket = s3.buckets['jf-devcasts']
        vid = bucket.objects[s3_filename]
        vid.url_for(:read, :expires => 60).to_s
      end
    end
  end
end

