# frozen_string_literal: true

module TrueConf
  class Response
    extend Dry::Initializer

    def error?
      is_a?(TrueConf::Error)
    end

    def success?
      !error?
    end

    class << self
      def build(*res)
        body = res.last
        attr = name.split('::').last.downcase
        new JSON.parse(body.first)[attr]
      end

      def new(opts)
        super opts.each_with_object({}) { |(key, val), obj| obj[key.to_sym] = val }
      end
    end
  end
end
