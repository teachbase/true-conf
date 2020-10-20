# frozen_string_literal: true

module TrueConf
  module Entity
    class InvitationSimple < TrueConf::Response
      option :id, proc(&:to_s), optional: true

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
