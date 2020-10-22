# frozen_string_literal: true

module TrueConf
  module Entity
    class RecordList < TrueConf::Response
      option :records, [Entity::Record], as: :data

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
