# frozen_string_literal: true

module TrueConf
  module Entity
    class DateTime < TrueConf::Response
      extend TrueConf::Callable

      option :date, proc(&:to_s)
      option :timezone_type, proc(&:to_i)
      option :timezone, proc(&:to_s)
    end
  end
end
