# frozen_string_literal: true

module TrueConf
  class AuthMethodType < String
    extend TrueConf::Callable

    METHODS = %w[oauth api_key].freeze

    METHODS.each do |method|
      define_method("#{method}?") do
        @auth_method == method
      end
    end

    private

    def initialize(value)
      @auth_method = value.to_s
      super @auth_method
    end
  end
end
