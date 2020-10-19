# frozen_string_literal: true

module TrueConf
  Client.scope :conferences do
    option :conference_id, proc(&:to_s)
    scope :participants do
      operation :list do
        http_method :get
        path { "/conferences/#{conference_id}/participants" }

        response(200) do |*res|
          Entity::Participant.build(*res)
        end

        response(403, 404) do |*res|
          Error.build(*res)
        end
      end

      operation :get do
        option :participant_id, proc(&:to_s)

        http_method :get
        path { "/conferences/#{conference_id}/participants/#{participant_id}" }

        response(200) do |*res|
          Entity::Participant.build(*res)
        end

        response(403, 404) do |*res|
          Error.build(*res)
        end
      end

      operation :invite do
        http_method :post
        path { "/conferences/#{conference_id}/participants" }
        format 'json'
        body do
          { participant_id: 'tbadmin' }
        end

        response(200) do |*res|
          Entity::Participant.build(*res)
        end

        response(400, 403, 404) do |*res|
          Error.build(*res)
        end
      end
    end
  end
end
