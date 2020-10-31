# frozen_string_literal: true

require "oauth2"
require "pry"

module TrueConf
  class Client < Evil::Client
    option :client_id, proc(&:to_s)
    option :client_secret, proc(&:to_s)
    option :api_server, proc(&:to_s)
    option :token_url, proc(&:to_s), default: -> { "/oauth2/v1/token" }
    option :version, proc(&:to_s), default: -> { "3.1" }

    format "json"
    path { "https://#{api_server}/api/#{version}" }

    class Resolver::Security < Resolver
      def access_token(client_id, client_secret)
        client = OAuth2::Client.new(
          client_id,
          client_secret,
          site: "https://#{api_server}",
          token_url: token_url
        )
        client.client_credentials.get_token.token
      end
    end

    security do
      token_auth(access_token(client_id, client_secret), inside: :query)
    end
  end
end
