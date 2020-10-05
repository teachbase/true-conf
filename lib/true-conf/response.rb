# frozen_string_literal: true

module TrueConf
  class Response
    extend Dry::Initializer

    class << self
      def build(*res)
        body = res.last
        new JSON.parse(body.first)["conference"]
      end

      def new(opts)
        super opts.each_with_object({}) { |(key, val), obj| obj[key.to_sym] = val }
      end
    end
  end
end
