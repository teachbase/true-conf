# frozen_string_literal: true

module TrueConf
  Client.scope :by_conference do
    option :conference_id, proc(&:to_s)
    path { "/conferences/#{conference_id}/invitations" }
    format 'json'

    scope :invitations do
      operation :all do
        http_method :get

        response(200) { |*res| Entity::InvitationList.build(*res).data }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :create do
        option :id, proc(&:to_s)
        option :display_name, proc(&:to_s), optional: true
        option :url_type, proc(&:to_s), optional: true

        http_method :post
        body { options.slice(:id, :display_name, :url_type) }

        response(200) { |*res| Entity::Invitation.build(*res) }
        response(400, 403, 404) { |*res| Error.build(*res) }
      end
    end

    scope :by_invitation do
      option :id, proc(&:to_s)
      path { "/#{id}" }
      format 'json'

      operation :get do
        http_method :get

        response(200) { |*res| Entity::Invitation.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :update do
        option :display_name, proc(&:to_s), optional: true
        option :url_type, proc(&:to_s), optional: true

        http_method :put
        body { options.slice(:display_name, :url_type) }

        response(200) { |*res| Entity::Invitation.build(*res) }
        response(400, 403, 404) { |*res| Error.build(*res) }
      end

      operation :delete do
        http_method :delete

        response(200) { |*res| Entity::InvitationSimple.build(*res) }
        response(400, 403, 404) { |*res| Error.build(*res) }
      end
    end
  end
end
