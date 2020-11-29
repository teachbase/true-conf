# frozen_string_literal: true

module TrueConf
  Client.scope :logs do
    path { "/logs" }
    format "json"

    scope :calls do
      path { "/calls" }
      format "json"

      operation :all do
        http_method :get

        response(200) { |*res| Entity::CallList.build(*res) }
        response(400, 403) { |*res| Error.build(*res) }
      end
    end

    scope :by_call do
      option :id, proc(&:to_s)

      path { "/calls/#{id}" }
      format "json"

      operation :get do
        http_method :get

        response(200) { |*res| Entity::Call.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :participants do
        path { "/participants" }
        http_method :get

        response(200) { |*res| Entity::CallParticipantList.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end
    end
  end
end
