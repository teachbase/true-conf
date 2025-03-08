# frozen_string_literal: true

RSpec.describe TrueConf::Client do
  let(:settings) { {client_id: "client_id", client_secret: "client_secret", api_server: "trueconf.local"} }
  let(:client) { described_class.new(**settings) }
  let(:conference_id) { "5576502892" }

  before do
    client = instance_double(OAuth2::Client)
    strategy = instance_double(OAuth2::Strategy::ClientCredentials)
    allow(OAuth2::Client).to receive(:new).and_return(client)
    allow(client).to receive(:client_credentials).and_return(strategy)
    allow(strategy).to receive(:get_token).and_return(OpenStruct.new(token: "access_token"))
  end

  shared_examples "returns_invitation_object" do
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
      expect(subject.is_owner).to eq 1
      expect(subject.type).to eq "user"

      expect(subject.owner?).to eq true
      expect(subject.user?).to eq true
      expect(subject.custom?).to eq false
    end
  end

  shared_examples "returns_invitation_list_object" do
    it "returns success" do
      expect(subject).to be_kind_of Array
      expect(subject.first).to be_kind_of TrueConf::Entity::Invitation
      expect(subject.first.id).to eq "admin"
      expect(subject.first.owner?).to eq true
    end
  end

  shared_examples "returns_not_found_error" do
    let(:body) { File.read("spec/fixtures/errors/not_found.json") }
    before { stub_request(:any, //).to_return(status: 404, body: body) }

    it "returns error" do
      expect(subject.error?).to eq true

      expect(subject).to be_kind_of TrueConf::Error
      expect(subject.code).to eq 404
      expect(subject.message).to eq "Not Found"

      expect(subject.errors).to be_kind_of Array
      expect(subject.errors.first).to be_kind_of TrueConf::ErrorDetail
      expect(subject.errors.first.reason).to eq "conferenceNotFound"
      expect(subject.errors.first.message).to eq "Conference '55765028992' is not found."
      expect(subject.errors.first.location_type).to eq "path"
      expect(subject.errors.first.location).to eq "conference_id"
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
    let(:invitation_id) { "admin" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/invitations/#{invitation_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/invitations/invitation.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject do
      client.by_conference(conference_id: conference_id)
        .by_invitation(id: invitation_id)
        .get
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_invitation_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#all" do
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/invitations?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/invitations/list.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject do
      client.by_conference(conference_id: conference_id)
        .invitations
        .all
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_invitation_list_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#create" do
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/invitations?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/invitations/invitation.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_conference(conference_id: conference_id)
        .invitations
        .create(id: "admin", display_name: "admin")
    end

    it "sends a request" do
      subject
      expect(a_request(:post, url)).to have_been_made
    end

    it_behaves_like "returns_invitation_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#update" do
    let(:invitation_id) { "admin" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/invitations/#{invitation_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/invitations/invitation.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_conference(conference_id: conference_id)
        .by_invitation(id: invitation_id)
        .update(display_name: "super admin")
    end

    it "sends a request" do
      subject
      expect(a_request(:put, url)).to have_been_made
    end

    it_behaves_like "returns_invitation_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#delete" do
    let(:invitation_id) { "admin" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/invitations/#{invitation_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/invitations/delete.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_conference(conference_id: conference_id)
        .by_invitation(id: invitation_id)
        .delete
    end

    it "sends a request" do
      subject
      expect(a_request(:delete, url)).to have_been_made
    end

    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.id).to eq invitation_id
    end

    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end
end
