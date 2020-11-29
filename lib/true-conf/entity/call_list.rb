# frozen_string_literal: true

module TrueConf
  module Entity
    class CallList < TrueConf::Response
      option :cnt, proc(&:to_i)
      option :list, [Entity::Call], as: :data

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
