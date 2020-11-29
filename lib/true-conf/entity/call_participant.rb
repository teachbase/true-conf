# frozen_string_literal: true

require_relative "./date_time"

module TrueConf
  module Entity
    class CallParticipant < TrueConf::Response
      extend TrueConf::Callable

      option :app_id, proc(&:to_s)
      option :avg_cpu_load, proc(&:to_i)
      option :avg_sent_fps, proc(&:to_i)
      option :bitrate_in, proc(&:to_i)
      option :bitrate_out, proc(&:to_i)
      option :call_id, proc(&:to_s)
      option :display_name, proc(&:to_s)
      option :duration, proc(&:to_i)
      option :join_time, Entity::DateTime, optional: true
      option :leave_reason, proc(&:to_i)
      option :leave_time, Entity::DateTime, optional: true
      option :video_h, proc(&:to_i)
      option :video_w, proc(&:to_i)

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
