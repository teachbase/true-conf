# frozen_string_literal: true

RSpec.describe TrueConf::Client do
  let(:settings) { {client_id: "client_id", client_secret: "client_secret", api_server: "trueconf.local"} }
  let(:client) { described_class.new(settings) }

  before do
    client = instance_double(OAuth2::Client)
    strategy = instance_double(OAuth2::Strategy::ClientCredentials)
    allow(OAuth2::Client).to receive(:new).and_return(client)
    allow(client).to receive(:client_credentials).and_return(strategy)
    allow(strategy).to receive(:get_token).and_return(OpenStruct.new(token: "access_token"))
  end

  shared_examples "returns_user_object" do
    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.id).to eq "admin"
      expect(subject.uid).to eq "admin@ru1pe2.trueconf.name"
      expect(subject.avatar).to eq nil
      expect(subject.login_name).to eq "admin"
      expect(subject.email).to eq "admin@ru1pe2.trueconf.name"
      expect(subject.display_name).to eq "Admin"
      expect(subject.first_name).to eq "Admin"
      expect(subject.last_name).to eq ""
      expect(subject.company).to eq "Teachbase"
      expect(subject.mobile_phone).to eq "+79876543210"
      expect(subject.work_phone).to eq "(8555) 32-32-32"
      expect(subject.home_phone).to eq "(8552) 123-123"
      expect(subject.is_active).to eq 1
      expect(subject.status).to eq 0

      expect(subject.not_active?).to eq false
      expect(subject.invalid?).to eq false
      expect(subject.offline?).to eq true
      expect(subject.online?).to eq false
      expect(subject.busy?).to eq false
      expect(subject.multihost?).to eq false
      expect(subject.enabled?).to eq true
      expect(subject.disabled?).to eq false
    end
  end

  shared_examples "returns_user_list_object" do
    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.next_page_id).to eq(-1)
      expect(subject.data).to be_kind_of Array
      expect(subject.data.first).to be_kind_of TrueConf::Entity::User
      expect(subject.data.first.login_name).to eq "admin"
    end
  end

  shared_examples "returns_not_found_error" do
    let(:body) { File.read("spec/fixtures/errors/users/not_found.json") }
    before { stub_request(:any, //).to_return(status: 404, body: body) }

    it "returns error" do
      expect(subject.error?).to eq true

      expect(subject).to be_kind_of TrueConf::Error
      expect(subject.code).to eq 404
      expect(subject.message).to eq "Not Found"

      expect(subject.errors).to be_kind_of Array
      expect(subject.errors.first).to be_kind_of TrueConf::ErrorDetail
      expect(subject.errors.first.reason).to eq "userNotFound"
      expect(subject.errors.first.message).to eq "User 'user' is not found"
      expect(subject.errors.first.location_type).to eq "path"
      expect(subject.errors.first.location).to eq "user_id"
    end
  end

  shared_examples "returns_bad_request_error" do
    let(:body) { File.read("spec/fixtures/errors/users/bad_request.json") }
    before { stub_request(:any, //).to_return(status: 400, body: body) }

    it "returns error" do
      expect(subject.error?).to eq true

      expect(subject).to be_kind_of TrueConf::Error
      expect(subject.code).to eq 400
      expect(subject.message).to eq "Bad Request"

      expect(subject.errors).to be_kind_of Array
      expect(subject.errors.first).to be_kind_of TrueConf::ErrorDetail
      expect(subject.errors.first.reason).to eq "uniqueValueAlreadyInUse"
      expect(subject.errors.first.message).to eq "Value is already in use. Please try another."
      expect(subject.errors.first.location_type).to eq "parameter"
      expect(subject.errors.first.location).to eq "login_name"
    end
  end

  shared_examples "returns_forbidden_error" do
    let(:body) { File.read("spec/fixtures/errors/forbidden.json") }
    before { stub_request(:any, //).to_return(status: 403, body: body) }

    it "returns error" do
      expect(subject.error?).to eq true

      expect(subject).to be_kind_of TrueConf::Error
      expect(subject.code).to eq 403
      expect(subject.message).to eq "Forbidden"

      expect(subject.errors).to be_kind_of Array
      expect(subject.errors.first).to be_kind_of TrueConf::ErrorDetail
      expect(subject.errors.first.reason).to eq "forbidden"
      expect(subject.errors.first.message).to eq "Forbidden"
    end
  end

  describe "#get" do
    let(:id) { "admin" }
    let(:url) { "https://trueconf.local/api/v3.1/users/#{id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/users/user.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject do
      client.by_user(id: id).get
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_user_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#all" do
    let(:url) { "https://trueconf.local/api/v3.1/users?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/users/list.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject { client.users.all }

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_user_list_object"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#create" do
    let(:params) { JSON.parse(File.read("spec/fixtures/input/user.json")).transform_keys(&:to_sym) }
    let(:url) { "https://trueconf.local/api/v3.1/users?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/users/user.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject { client.users.create(**params) }

    it "sends a request" do
      subject
      expect(a_request(:post, url)).to have_been_made
    end

    it_behaves_like "returns_user_object"
    it_behaves_like "returns_bad_request_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#update" do
    let(:id) { "admin" }
    let(:params) { JSON.parse(File.read("spec/fixtures/input/user.json")).transform_keys(&:to_sym) }
    let(:url) { "https://trueconf.local/api/v3.1/users/#{id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/users/user.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_user(id: id).update(**params)
    end

    it "sends a request" do
      subject
      expect(a_request(:put, url)).to have_been_made
    end

    it_behaves_like "returns_user_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#delete" do
    let(:id) { "admin" }
    let(:url) { "https://trueconf.local/api/v3.1/users/#{id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/users/delete.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_user(id: id).delete
    end

    it "sends a request" do
      subject
      expect(a_request(:delete, url)).to have_been_made
    end

    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.id).to eq id
    end

    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#disconnect" do
    let(:id) { "admin" }
    let(:url) { "https://trueconf.local/api/v3.1/users/#{id}/disconnect?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/users/disconnect.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_user(id: id).disconnect
    end

    it "sends a request" do
      subject
      expect(a_request(:post, url)).to have_been_made
    end

    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.state).to eq "disconnecting"
    end

    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end
end
