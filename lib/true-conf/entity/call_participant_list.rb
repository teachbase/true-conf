# frozen_string_literal: true

require_relative "./call_participant"

module TrueConf
  module Entity
    class CallParticipantList < TrueConf::Response
      option :cnt, proc(&:to_i)
      option :list, [Entity::CallParticipant], as: :data

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
