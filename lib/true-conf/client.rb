# frozen_string_literal: true

require "true-conf/callable"
require "true-conf/types/auth_method_type"

I18n.load_path += [File.expand_path("../config/locales/en.yml", __FILE__)]

module TrueConf
  class Client < Evil::Client
    option :auth_method, AuthMethodType, default: -> { "oauth" }
    option :client_id, proc(&:to_s), optional: true
    option :client_secret, proc(&:to_s), optional: true
    option :client_token, proc(&:to_s), optional: true
    option :api_server, proc(&:to_s)
    option :token_url, proc(&:to_s), default: -> { "/oauth2/v1/token" }
    option :version, proc(&:to_s), default: -> { "v3.1" }

    validate do
      return if AuthMethodType::METHODS.include?(auth_method)

      errors.add :invalid_auth_method, field: "auth_method", level: "error"
    end
    validate { errors.add :token_missed if (auth_method.token? && client_token.nil?) }
    validate { errors.add :client_id_missed if (auth_method.oauth? && client_id.nil?) }
    validate { errors.add :client_secret_missed if (auth_method.oauth? && client_secret.nil?) }
    validate { errors.add :unsupported_api_version unless %w[v3.1 v3.2].include?(version) }

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
      token = auth_method.oauth? ? access_token(client_id, client_secret) : client_token
      token_auth(token, inside: :query)
    end
  end
end
