# frozen_string_literal: true

module TrueConf
  class ErrorDetail
    extend Dry::Initializer
    extend TrueConf::Callable
    include TrueConf::Optional

    option :reason, proc(&:to_s)
    option :message, proc(&:to_s)
    option :locationType, proc(&:to_s), optional: true, as: :location_type
    option :location, proc(&:to_s), optional: true
  end
end
