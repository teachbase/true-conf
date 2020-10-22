# frozen_string_literal: true

module TrueConf
  Client.scope :by_conference do
    scope :records do
      path { '/records' }
      format 'json'

      operation :all do
        option :url_type, proc(&:to_s), optional: true

        http_method :get
        query { options.slice(:url_type) }

        response(200) { |*res| Entity::RecordList.build(*res).data }
        response(400, 403) { |*res| Error.build(*res) }
      end
    end

    scope :by_record do
      option :id, proc(&:to_s)

      path { "/records/#{id}" }
      format 'json'

      operation :get do
        option :url_type, proc(&:to_s), optional: true

        http_method :get
        query { options.slice(:url_type) }

        response(200) { |*res| Entity::Record.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end

      operation :download do
        path { '/download' }
        option :url_type, proc(&:to_s), optional: true

        http_method :get
        query { options.slice(:url_type) }

        response(200) { |*res| Entity::Record.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end
    end
  end
end
