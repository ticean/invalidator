module Invalidator
  module Configuration
    VALID_OPTIONS_KEYS = [
      :safe_mode,
      :aws_access_key_id,
      :aws_secret_access_key,
      :aws_region,
      :cf_distribution_id,
      :s3_bucket
    ]

    DEFAULT_SAFE_MODE = true
    DEFAULT_AWS_ACCESS_KEY_ID = nil
    DEFAULT_AWS_SECRET_ACCESS_KEY = nil
    DEFAULT_AWS_REGION = 'us-east-1'
    DEFAULT_CF_DISTRIBUTION_ID = nil
    DEFAULT_S3_BUCKET = nil

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end


    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    def reset
      self.safe_mode = DEFAULT_SAFE_MODE
      self.aws_access_key_id = DEFAULT_AWS_ACCESS_KEY_ID
      self.aws_secret_access_key = DEFAULT_AWS_SECRET_ACCESS_KEY
      self.aws_region = DEFAULT_AWS_REGION
      self.cf_distribution_id = DEFAULT_CF_DISTRIBUTION_ID
      self.s3_bucket = DEFAULT_S3_BUCKET
    end

    def validate!
      # All options are required.
      VALID_OPTIONS_KEYS.each do |k|
        raise Invalidator::ConfigurationError.new "#{k} cannot be nil" \
          unless self.send(k)
      end
      true
    end

  end
end
