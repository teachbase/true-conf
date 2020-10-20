# frozen_string_literal: true

module TrueConf
  module Entity
    class InvitationList < TrueConf::Response
      option :invitations, [Entity::Invitation]

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
