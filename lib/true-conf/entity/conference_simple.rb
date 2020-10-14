# frozen_string_literal: true

module TrueConf
  module Entity
    class ConferenceSimple < TrueConf::Response
      option :id, proc(&:to_s), optional: true
      option :owner, proc(&:to_s), optional: true
      option :state, proc(&:to_s), optional: true

      %w[running stopped].each do |method|
        define_method("#{method}?") do
          !state.nil? && state == method
        end
      end

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
