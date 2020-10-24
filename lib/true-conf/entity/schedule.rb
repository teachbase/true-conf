# frozen_string_literal: true

module TrueConf
  module Entity
    class Schedule
      extend Dry::Initializer
      extend TrueConf::Callable
      include TrueConf::Optional

      SCHEDULE_TYPE = {
        none: -1,
        weekly: 0,
        one_time: 1
      }.freeze

      option :type, proc(&:to_i)
      option :start_time, proc(&:to_i), optional: true
      option :duration, proc(&:to_i), optional: true

      option :days, [proc(&:to_s)], optional: true
      option :time, proc(&:to_s), optional: true
      option :time_offset, proc(&:to_i), optional: true

      SCHEDULE_TYPE.each do |method_name, value|
        define_method("#{method_name}?") do
          type == value
        end
      end
    end
  end
end
