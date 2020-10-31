# frozen_string_literal: true

module TrueConf
  Client.scope :users do
    path { "/users" }
    format "json"

    operation :all do
      option :url_type, proc(&:to_s), optional: true
      option :page_id, proc(&:to_i), optional: true
      option :page_size, proc(&:to_i), optional: true
      option :login_name, proc(&:to_s), optional: true
      option :display_name, proc(&:to_s), optional: true
      option :first_name, proc(&:to_s), optional: true
      option :last_name, proc(&:to_s), optional: true
      option :email, proc(&:to_s), optional: true

      http_method :get
      query do
        options.slice(:url_type, :page_id, :page_size, :login_name,
          :display_name, :first_name, :last_name, :email)
      end

      response(200) { |*res| Entity::UserList.build(*res) }
      response(400, 403) { |*res| Error.build(*res) }
    end

    operation :create do
      option :login_name, proc(&:to_s)
      option :email, proc(&:to_s)
      option :password, proc(&:to_s)
      option :display_name, proc(&:to_s), optional: true
      option :first_name, proc(&:to_s), optional: true
      option :last_name, proc(&:to_s), optional: true
      option :company, proc(&:to_s), optional: true
      option :mobile_phone, proc(&:to_s), optional: true
      option :work_phone, proc(&:to_s), optional: true
      option :home_phone, proc(&:to_s), optional: true
      option :is_active, proc(&:to_i), optional: true

      http_method :post
      body do
        options.slice(:login_name, :email, :password, :display_name, :first_name, :last_name,
                      :company, :mobile_phone, :work_phone, :home_phone, :is_active)
      end

      response(200) { |*res| Entity::User.build(*res) }
      response(400, 403) { |*res| Error.build(*res) }
    end
  end

  Client.scope :by_user do
    option :id, proc(&:to_s)
    path { "/users/#{id}" }
    format "json"

    operation :get do
      option :url_type, proc(&:to_s), optional: true

      http_method :get
      query { options.slice(:url_type) }

      response(200) { |*res| Entity::User.build(*res) }
      response(403, 404) { |*res| Error.build(*res) }
    end

    operation :update do
      option :url_type, proc(&:to_s), optional: true
      option :email, proc(&:to_s), optional: true
      option :password, proc(&:to_s), optional: true
      option :display_name, proc(&:to_s), optional: true
      option :first_name, proc(&:to_s), optional: true
      option :last_name, proc(&:to_s), optional: true
      option :company, proc(&:to_s), optional: true
      option :mobile_phone, proc(&:to_s), optional: true
      option :work_phone, proc(&:to_s), optional: true
      option :home_phone, proc(&:to_s), optional: true
      option :is_active, proc(&:to_i), optional: true

      http_method :put
      query { options.slice(:url_type) }
      body do
        options.slice(:login_name, :email, :password, :display_name, :first_name, :last_name,
          :company, :mobile_phone, :work_phone, :home_phone, :is_active)
      end

      response(200) { |*res| Entity::User.build(*res) }
      response(400, 403, 404) { |*res| Error.build(*res) }
    end

    operation :delete do
      http_method :delete

      response(200) { |*res| Entity::UserSimple.build(*res) }
      response(403, 404) { |*res| Error.build(*res) }
    end

    operation :disconnect do
      http_method :post
      path { "/disconnect" }

      response(200) { |*res| Entity::UserSimple.build(*res) }
      response(400, 403, 404) { |*res| Error.build(*res) }
    end
  end
end
