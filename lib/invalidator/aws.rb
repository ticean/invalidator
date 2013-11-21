require 'aws'
require 'aws/s3'

module Invalidator
  class AWS

    # Remove the item from S3.
    # @param s3 (AWS::S3) An S3 instance.
    # @param bucket_name (String) An S3 bucket name.
    # @param paths (Array) A list of paths that should be deleted from S3.
    # @param safe_mode (Boolean) Performs a dry run when true.
    #
    def s3_delete(s3, bucket_name, paths, safe_mode=true)
      bucket = s3.buckets[bucket_name]
      paths.each do |k|
        path = strip_leading_slash(k)
        begin
          obj = bucket.objects[path]
          if safe_to_delete?(obj)
            puts "Deleting from S3: #{k} #{"(safe mode)" if safe_mode}"
            obj.delete unless safe_mode
          else
            puts "Unsafe, not deleting from S3: #{k}"
          end
        rescue ::AWS::S3::Errors::NoSuchKey
          puts "S3 key doesn't exist: #{k} #{"(safe mode)" if safe_mode}"
        end
      end
    end


    # Create a Cloudfront Invalidation.
    # @param cf AWS::CloudFront A CloudFront instance
    # @param distribution_id (String) The CloudFront distribution id.
    # @param paths (Array) The object paths that should be invalidated.
    # @param safe_mode (Boolean) Performs a dry run when true.
    #
    def cf_invalidate(cf, distribution_id, paths, safe_mode=true)
      if safe_mode
        puts "In safe mode."
        puts "Not creating CloudFront invalidation."
      else
        cf.client.create_invalidation(
          distribution_id: distribution_id,
          invalidation_batch: {
            caller_reference: Invalidator::Checksum.signature(paths),
            paths: {
              quantity: paths.count,
              items: paths
            }
          }
        )
      end
    end

    # Strips the leading slash.
    def strip_leading_slash(val)
      val.sub(/^\//, "")
    end

    private

    # Returns true if the object is safe to delete.
    # Not a 100% sure-fire, but generally trying to check if the object is a
    # file or a directory. We don't ever want to delete a directory.
    # @param obj AWS::S3::S3Object
    #
    def safe_to_delete?(obj)
      obj.content_length > 1000 && !obj.content_type.empty?
    end

  end
end
