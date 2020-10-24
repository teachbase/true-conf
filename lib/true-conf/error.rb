# frozen_string_literal: true

require_relative "./error_detail"

module TrueConf
  class Error < TrueConf::Response
    extend Dry::Initializer
    extend TrueConf::Callable
    include TrueConf::Optional

    option :code, proc(&:to_i)
    option :message, proc(&:to_s)
    option :errors, [TrueConf::ErrorDetail], optional: true
  end
end
