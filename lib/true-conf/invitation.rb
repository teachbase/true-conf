# frozen_string_literal: true

module TrueConf
  Client.scope :by_conference do
    option :conference_id, proc(&:to_s)

    scope :invitations do
      operation :list do
        http_method :get
        path { "/conferences/#{conference_id}/invitations" }

        response(200) { |*res| Entity::InvitationList.build(*res).data }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :get do
        option :invitation_id, proc(&:to_s)

        http_method :get
        path { "/conferences/#{conference_id}/invitations/#{invitation_id}" }

        response(200) { |*res| Entity::Invitation.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :add do
        option :id, proc(&:to_s)
        option :display_name, proc(&:to_s), optional: true
        option :url_type, proc(&:to_s), optional: true

        http_method :post
        path { "/conferences/#{conference_id}/invitations" }
        format 'json'
        body { options.slice(:id, :display_name, :url_type) }

        response(200) { |*res| Entity::Invitation.build(*res) }
        response(400, 403, 404) { |*res| Error.build(*res) }
      end

      operation :update do
        option :invitation_id, proc(&:to_s)
        option :display_name, proc(&:to_s), optional: true
        option :url_type, proc(&:to_s), optional: true

        http_method :put
        path { "/conferences/#{conference_id}/invitations/#{invitation_id}" }
        format 'json'
        body { options.slice(:display_name, :url_type) }

        response(200) { |*res| Entity::Invitation.build(*res) }
        response(400, 403, 404) { |*res| Error.build(*res) }
      end

      operation :delete do
        option :invitation_id, proc(&:to_s)

        http_method :delete
        path { "/conferences/#{conference_id}/invitations/#{invitation_id}" }
        format 'json'

        response(200) { |*res| Entity::InvitationSimple.build(*res) }
        response(400, 403, 404) { |*res| Error.build(*res) }
      end
    end
  end
end
