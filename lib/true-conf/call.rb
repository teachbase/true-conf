# frozen_string_literal: true

module TrueConf
  Client.scope :logs do
    path { "/logs" }
    format "json"

    scope :calls do
      path { "/calls" }
      format "json"

      operation :all do
        option :timezone, proc(&:to_i), optional: true
        option :page_size, proc(&:to_i), optional: true
        option :page_id, proc(&:to_i), optional: true
        option :sort_field, proc(&:to_s), optional: true
        option :sort_order, proc(&:to_i), optional: true
        option :date_from, proc(&:to_s), optional: true
        option :date_to, proc(&:to_s), optional: true
        option :named_conf_id, proc(&:to_s), optional: true

        http_method :get
        query do
          options.slice(:timezone, :page_size, :page_id, :sort_field,
            :sort_order, :date_from, :date_to, :named_conf_id)
        end

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
        option :timezone, proc(&:to_i), optional: true
        option :page_size, proc(&:to_i), optional: true
        option :page_id, proc(&:to_i), optional: true
        option :sort_field, proc(&:to_s), optional: true
        option :sort_order, proc(&:to_i), optional: true
        option :date_from, proc(&:to_s), optional: true
        option :date_to, proc(&:to_s), optional: true
        option :call_id, proc(&:to_s), optional: true

        query do
          options.slice(:timezone, :page_size, :page_id, :sort_field,
            :sort_order, :date_from, :date_to, :call_id)
        end
        path { "/participants" }
        http_method :get

        response(200) { |*res| Entity::CallParticipantList.build(*res) }
        response(403, 404) { |*res| Error.build(*res) }
      end
    end
  end
end
