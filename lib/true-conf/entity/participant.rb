# frozen_string_literal: true

require_relative './schedule'

module TrueConf
  module Entity
    class Participant < TrueConf::Response
      option :id, proc(&:to_s)
      option :uid, proc(&:to_s), optional: true
      option :avatar, proc(&:to_s), optional: true
      option :login_name, proc(&:to_s), optional: true
      option :email, proc(&:to_s), optional: true
      option :display_name, proc(&:to_s), optional: true
      option :first_name, proc(&:to_s), optional: true
      option :last_name, proc(&:to_s), optional: true
      option :company, proc(&:to_s), optional: true
      option :groups, method(:Array), optional: true
      option :mobile_phone, proc(&:to_s), optional: true
      option :work_phone, proc(&:to_s), optional: true
      option :home_phone, proc(&:to_s), optional: true
      option :is_active, proc(&:to_i), optional: true
      option :status, proc(&:to_i), optional: true
      option :join_time, proc(&:to_i), optional: true
      option :is_owner, optional: true
    end
  end
end
