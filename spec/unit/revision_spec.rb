require "spec_helper"
require_relative "../../models/revision"
require_relative '../support/aws_stubs'


include Devcasts::Models

describe Revision do
  describe "#hour_s3_url" do
    it "loads the url from AWS S3" do
      rev = build(:revision, s3_url: 'foo')
      # this works because of the aws_stubs
      expect(rev.hour_s3_url).to eq('http://video.s3.com')
    end
  end
end
