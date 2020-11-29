# frozen_string_literal: true

require_relative "./date_time"

module TrueConf
  module Entity
    class Call < TrueConf::Response
      extend TrueConf::Callable

      option :conference_id, proc(&:to_s)
      option :named_conf_id, proc(&:to_s), optional: true
      option :topic, proc(&:to_s)
      option :class, proc(&:to_i)
      option :type, proc(&:to_i)
      option :subtype, proc(&:to_i)
      option :owner, proc(&:to_s)
      option :participant_count, proc(&:to_i)
      option :start_time, Entity::DateTime, optional: true
      option :duration, proc(&:to_i)
      option :end_time, Entity::DateTime, optional: true

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
