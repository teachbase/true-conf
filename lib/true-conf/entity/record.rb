# frozen_string_literal: true

module TrueConf
  module Entity
    class Record < TrueConf::Response
      extend TrueConf::Callable

      option :name, proc(&:to_s)
      option :size, proc(&:to_s)
      option :created, proc(&:to_i)
      option :download_url, proc(&:to_s)
    end
  end
end
