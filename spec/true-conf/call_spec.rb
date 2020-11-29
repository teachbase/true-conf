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

  shared_examples "returns_call_object" do
    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject).to be_kind_of TrueConf::Entity::Call
      expect(subject.conference_id).to eq "0000001b@ru1pe2.trueconf.name#vcs"
      expect(subject.named_conf_id).to eq "1067013335"
      expect(subject.class).to eq 10
      expect(subject.type).to eq 5
      expect(subject.subtype).to eq 0
      expect(subject.owner).to eq "admin@ru1pe2.trueconf.name"
      expect(subject.participant_count).to eq 2
      expect(subject.start_time).to be_kind_of TrueConf::Entity::DateTime
      expect(subject.start_time.date).to eq "2020-10-31 23:05:45.000000"
      expect(subject.start_time.timezone_type).to eq 3
      expect(subject.start_time.timezone).to eq "Europe/London"
      expect(subject.duration).to eq 190
      expect(subject.end_time).to be_kind_of TrueConf::Entity::DateTime
      expect(subject.end_time.date).to eq "2020-10-31 23:08:55.306514"
      expect(subject.end_time.timezone_type).to eq 3
      expect(subject.end_time.timezone).to eq "Europe/London"
    end
  end

  shared_examples "returns_call_list_object" do
    it "returns success" do
      expect(subject.cnt).to eq 3
      expect(subject.data).to be_kind_of Array
      expect(subject.data.first).to be_kind_of TrueConf::Entity::Call
      expect(subject.data.first.named_conf_id).to eq "8169600686"
    end
  end

  shared_examples "returns_call_participant_list_object" do
    it "returns success" do
      expect(subject.cnt).to eq 2
      expect(subject.data).to be_kind_of Array
      expect(subject.data.first).to be_kind_of TrueConf::Entity::CallParticipant
      expect(subject.data.first.app_id).to eq "3E5BCC44DE50C1F5DA9EC8D98C2BB0C1"
      expect(subject.data.last.app_id).to eq "CE2A60BD85AAF38F124A0D9289A2F8C7"
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
    let(:call_id) { 123 }
    let(:url) { "https://trueconf.local/api/v3.1/logs/calls/#{call_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/calls/call.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject { client.logs.by_call(id: call_id).get }

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_call_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#all" do
    let(:url) { "https://trueconf.local/api/v3.1/logs/calls?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/calls/list.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject { client.logs.calls.all }

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_call_list_object"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#participants" do
    let(:call_id) { 123 }
    let(:url) { "https://trueconf.local/api/v3.1/logs/calls/#{call_id}/participants?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/calls/participants.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject { client.logs.by_call(id: call_id).participants }

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_call_participant_list_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end
end
