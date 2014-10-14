module Net
  class HTTP
    class Signature
      class Signer
        def initialize(request:, algorithm:, secret:)
          @request = request
          @algorithm = algorithm
          @secret = secret

          unless @algorithm =~ /.+-.+/
            fail ArgumentError, "Invalid algorithm format: {{key}}-{{digester}}"
          end

          unless key
            fail ArgumentError, "Crypto scheme not supported"
          end
        end

        def algorithm
          @algorithm
        end

        def to_s
          Base64.encode64(key.update(request).digest)
        end

        private def secret
          @secret
        end

        private def request
          @request.to_s
        end

        private def key
          case algorithm.split("-").first
          when "hmac" then OpenSSL::HMAC.new(secret, digester)
          end
        end

        private def digester
          algorithm.split("-").last.upcase
        end
      end
    end
  end
end
