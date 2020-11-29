# frozen_string_literal: true

module TrueConf
  class AuthMethod < String
    extend TrueConf::Callable

    AUTH_METHODS = %w[oauth token].freeze

    AUTH_METHODS.each do |method|
      define_method("#{method}?") do
        @auth_method == method
      end
    end

    private

    def initialize(value)
      @auth_method = value.to_s
      raise TrueConf::ParameterValueNotPermitted unless AUTH_METHODS.include?(@auth_method)
      super @auth_method
    end
  end
end
