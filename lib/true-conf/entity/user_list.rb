# frozen_string_literal: true

module TrueConf
  module Entity
    class UserList < TrueConf::Response
      option :next_page_id, proc(&:to_i), optional: true
      option :users, [Entity::User], as: :data

      class << self
        def build(*res)
          body = res.last
          new JSON.parse(body.first)
        end
      end
    end
  end
end
