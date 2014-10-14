module Net
  class HTTP
    class Signature
      class Request
        def initialize(verb:, uri:, headers:, body:)
          @verb = verb
          @uri = uri
          @headers = headers
          @body = body

          fail ArgumentError, "Date header required" unless @headers.key?("Date")
        end

        def to_s
          "#{verb} #{uri} #{headers} #{body}"
        end

        private def headers
          @headers.to_a.sort_by(&:first).map { |(key, value)| "#{key}: #{value}" }.join("\n")
        end

        private def verb
          @verb.upcase
        end

        private def uri
          @uri
        end

        private def body
          @body
        end
      end
    end
  end
end
