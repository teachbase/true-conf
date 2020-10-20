# frozen_string_literal: true

module TrueConf
  module Entity
    class User < TrueConf::Response
      extend TrueConf::Callable

      STATUSES = {
        not_active: -2,
        invalid: -1,
        offline: 0,
        online: 1,
        busy: 2,
        multihost: 3
      }.freeze

      ACTIVITIES = {
        disabled: 0,
        enabled: 1
      }.freeze

      option :id, proc(&:to_s)
      option :uid, proc(&:to_s)
      option :avatar
      option :login_name, proc(&:to_s)
      option :email, proc(&:to_s)
      option :display_name, proc(&:to_s)
      option :first_name, proc(&:to_s)
      option :last_name, proc(&:to_s)
      option :company, proc(&:to_s)
      option :groups, method(:Array)
      option :mobile_phone, proc(&:to_s)
      option :work_phone, proc(&:to_s)
      option :home_phone, proc(&:to_s)
      option :is_active, proc(&:to_i)
      option :status, proc(&:to_i)

      STATUSES.each do |method_name, value|
        define_method("#{method_name}?") do
          status == value
        end
      end

      ACTIVITIES.each do |method_name, value|
        define_method("#{method_name}?") do
          is_active == value
        end
      end
    end
  end
end
