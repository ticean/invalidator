require File.expand_path('../invalidator/aws', __FILE__)
require File.expand_path('../invalidator/checksum', __FILE__)
require File.expand_path('../invalidator/configuration', __FILE__)
require File.expand_path('../invalidator/error', __FILE__)

# Invalidator provides an easy way to delete items from S3 and create a
# CloudFront invalidation to remove the items from CDN.
#
# Example Usage:
#
#     require 'invalidator'
#
#     Invalidator.configure do |c|
#       c.safe_mode = true
#       c.aws_access_key_id = 'XXXX'
#       c.aws_secret_access_key = 'XXXX'
#       c.aws_region = 'us-east-1'
#       c.cf_distribution_id = 'XXXX'
#       c.s3_bucket = 'mybucket'
#     end
#
#     # These paths will be invalidated.
#     paths = %w(
#       /path/to/file1.jpg
#       /path/to/file2.jpg
#     )
#
#     Invalidator.invalidate(paths)
#
module Invalidator
  extend Configuration

  # Invalidates paths by deleting from S3 and creating a CloudFront invalidation.
  # @params paths Array An array of file paths that should be invalidated.
  #   Should have a leading slash, ex: '/path/to/my/file.jpg'
  #
  def self.invalidate(paths)
    puts "Will invalidate!"
    validate! # validate configuration

    # Create AWS objects.
    ::AWS.config(
      access_key_id: aws_access_key_id,
      secret_access_key: aws_secret_access_key,
      region: aws_region
    )
    aws = Invalidator::AWS.new
    s3  = ::AWS::S3.new
    cf  = ::AWS::CloudFront.new

    ## Do the work.
    aws.s3_delete(s3, s3_bucket, paths, safe_mode)
    aws.cf_invalidate(cf, cf_distribution_id, paths, safe_mode)
  end

end
