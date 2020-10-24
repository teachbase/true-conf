# frozen_string_literal: true

module TrueConf
  module Callable
    def call(*args)
      new(*args)
    end
    alias_method :[], :call
  end
end
