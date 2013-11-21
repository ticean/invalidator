module Invalidator
  module Checksum

    # Creates a MD5 signature from content.
    #
    def self.signature(body)
      flattened = self.flatten(body)
      Digest::MD5.hexdigest(flattened)
    end

    # Flattens an object to prepare it for MD5 summing.
    #
    def self.flatten(body)
      if body.class == Hash
        arr = []
        body.each do |key, value|
          arr << "#{self.flatten key}=>#{self.flatten value}"
        end
        body = arr
      end
      if body.class == Array
        str = ''
        body.map! do |value|
          self.flatten value
        end.sort!.each do |value|
          str << value
        end
      end
      if body.class != String
        body = body.to_s << body.class.to_s
      end
      body
    end
  end
end
