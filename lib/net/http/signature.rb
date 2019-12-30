require "base64"
require "openssl"

module Net
  class HTTP
    class Signature
      require_relative "signature/request"
      require_relative "signature/signer"
      require_relative "signature/version"

      HEADER = "Signature"

      def initialize(key:, signer:)
        @key = key
        @signer = signer
      end

      def valid?(string)
        to_s.strip == string.strip
      end

      def to_s
        "key=#{key} algorithm=#{algorithm} token=#{signer}"
      end

      def to_h
        {
          HEADER => to_s
        }
      end

      private def key
        @key
      end

      private def algorithm
        @signer.algorithm
      end

      private def signer
        @signer
      end
    end
  end
end
