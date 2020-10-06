# frozen_string_literal: true

module TrueConf
  Client.scope :conferences do
    operation :get do
      option :conference_id, proc(&:to_s)

      http_method :get
      path { "/conferences/#{conference_id}" }

      response(200) do |*res|
        Entity::Conference.build(*res)
      end

      response(403, 404) do |*res|
        Error.build(*res)
      end
    end

    operation :create do
      option :id, proc(&:to_s), optional: true
      option :topic, proc(&:to_s), optional: true
      option :description, proc(&:to_s), optional: true
      option :owner, proc(&:to_s), optional: true
      option :type, proc(&:to_i), optional: true
      option :schedule, optional: true
      option :allow_guests, optional: true
      option :auto_invite, proc(&:to_i), optional: true
      option :tags, optional: true
      option :max_participants, proc(&:to_i), optional: true
      option :rights, optional: true
      option :url, proc(&:to_s), optional: true
      option :webclient_url, proc(&:to_s), optional: true
      option :state, proc(&:to_s), optional: true
      option :recording, proc(&:to_i), optional: true

      http_method :post
      path { '/conferences' }
      format 'json'
      body do
        options.slice(:id, :topic, :description, :owner, :type, :schedule, :max_participants,
                      :rights, :allow_guests, :auto_invite, :tags, :url, :webclient_url, :state,
                      :recording)
      end

      response(200) do |*res|
        Entity::Conference.build(*res)
      end

      response(400, 403, 404) do |*res|
        Error.build(*res)
      end
    end

    operation :update do
      option :conference_id, proc(&:to_s)
      option :id, proc(&:to_s), optional: true
      option :topic, proc(&:to_s)
      option :description, proc(&:to_s)
      option :owner, proc(&:to_s)
      option :type, proc(&:to_i)
      option :schedule, optional: true
      option :allow_guests, optional: true
      option :auto_invite, proc(&:to_i), optional: true
      option :tags, optional: true
      option :max_participants, proc(&:to_i), optional: true
      option :rights, optional: true
      option :url, proc(&:to_s), optional: true
      option :webclient_url, proc(&:to_s), optional: true
      option :state, proc(&:to_s), optional: true
      option :recording, proc(&:to_i), optional: true

      http_method :put
      path { "/conferences/#{conference_id}" }
      format 'json'
      body do
        options.slice(:id, :topic, :description, :owner, :type, :schedule, :max_participants,
                      :rights, :allow_guests, :auto_invite, :tags, :url, :webclient_url, :state,
                      :recording)
      end

      response(200) do |*res|
        Entity::Conference.build(*res)
      end

      response(400, 403, 404) do |*res|
        Error.build(*res)
      end
    end

    operation :delete do
      option :conference_id, proc(&:to_s)
      http_method :delete
      path { "/conferences/#{conference_id}" }
      format 'json'

      response(200) { |*res| Entity::ConferenceSimple.build(*res) }
      response(400, 403, 404) { |*res| Error.build(*res) }
    end

    operation :run do
      option :conference_id, proc(&:to_s)
      http_method :post
      path { "/conferences/#{conference_id}/run" }
      format 'json'

      response(200) { |*res| Entity::ConferenceSimple.build(*res) }
      response(400, 403, 404) { |*res| Error.build(*res) }
    end

    operation :stop do
      option :conference_id, proc(&:to_s)
      http_method :post
      path { "/conferences/#{conference_id}/stop" }
      format 'json'

      response(200) { |*res| Entity::ConferenceSimple.build(*res) }
      response(400, 403, 404) { |*res| Error.build(*res) }
    end
  end
end
