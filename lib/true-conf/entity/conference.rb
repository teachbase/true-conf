# frozen_string_literal: true

require_relative "./schedule"

module TrueConf
  module Entity
    class Conference < TrueConf::Response
      CONFERENCE_TYPE = {
        symmetric: 0,
        asymmetric: 1,
        role_based: 3
      }.freeze

      option :id, proc(&:to_s)
      option :topic, proc(&:to_s)
      option :description, proc(&:to_s)
      option :owner, proc(&:to_s)
      option :type, proc(&:to_i)
      option :invitations, method(:Array), optional: true
      option :max_podiums, proc(&:to_i)
      option :max_participants, proc(&:to_i)
      option :schedule, Entity::Schedule
      option :allow_guests
      option :rights
      option :auto_invite, proc(&:to_i)
      option :url, proc(&:to_s)
      option :webclient_url, proc(&:to_s)
      option :state, proc(&:to_s)
      option :tags
      option :recording, proc(&:to_i)

      %w[running stopped].each do |method|
        define_method("#{method}?") do
          state == method
        end
      end

      CONFERENCE_TYPE.each do |method_name, value|
        define_method("#{method_name}?") do
          type == value
        end
      end
    end
  end
end
