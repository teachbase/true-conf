# frozen_string_literal: true

module TrueConf
  Client.scope :by_conference do
    option :conference_id, proc(&:to_s)

    scope :participants do
      operation :list do
        http_method :get
        path { "/conferences/#{conference_id}/participants" }

        response(200) { |*res| Entity::Participant.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :get do
        option :participant_id, proc(&:to_s)

        http_method :get
        path { "/conferences/#{conference_id}/participants/#{participant_id}" }

        response(200) { |*res| Entity::Participant.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :invite do
        option :participant_id, proc(&:to_s)

        http_method :post
        path { "/conferences/#{conference_id}/participants" }
        format 'json'
        body { { participant_id: participant_id } }

        response(200) { |*res| Entity::Participant.build(*res) }
        response(400, 403, 404) { |*res| Error.build(*res) }
      end
    end
  end
end
