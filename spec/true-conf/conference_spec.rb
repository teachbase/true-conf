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

  shared_examples "returns_conference_object" do
    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.id).to eq "5576502892"
      expect(subject.topic).to eq "Topic of conference"
      expect(subject.description).to eq "Description of conference"
      expect(subject.owner).to eq "user1@server.name"
      expect(subject.invitations).to eq nil
      expect(subject.max_podiums).to eq 25
      expect(subject.max_participants).to eq 25
      expect(subject.schedule).to be_kind_of TrueConf::Entity::Schedule
      expect(subject.schedule.type).to eq 1
      expect(subject.schedule.start_time).to eq 1_602_018_000
      expect(subject.schedule.time_offset).to eq 0
      expect(subject.schedule.duration).to eq 600
      expect(subject.allow_guests).to eq true
      expect(subject.auto_invite).to eq 0
      expect(subject.tags).to eq %w[tag1 tag2]
      expect(subject.recording).to eq 0

      expect(subject.running?).to eq false
      expect(subject.stopped?).to eq true

      expect(subject.symmetric?).to eq true
      expect(subject.asymmetric?).to eq false
      expect(subject.role_based?).to eq false
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

  describe "#get" do
    let(:conference_id) { "5576502892" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/conferences/conference.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject { client.by_conference(conference_id: conference_id).get }

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_conference_object"
    it_behaves_like "returns_not_found_error"
  end

  describe "#create" do
    let(:params) { JSON.parse(File.read("spec/fixtures/input/conference.json")).transform_keys(&:to_sym) }
    let(:url) { "https://trueconf.local/api/v3.1/conferences?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/conferences/conference.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.conferences.create(**params)
    end

    it "sends a request" do
      subject
      expect(a_request(:post, url)).to have_been_made
    end

    it_behaves_like "returns_conference_object"
    it_behaves_like "returns_not_found_error"
  end

  describe "#update" do
    let(:conference_id) { "5576502892" }
    let(:params) { JSON.parse(File.read("spec/fixtures/input/conference.json")).transform_keys(&:to_sym) }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/conferences/conference.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_conference(conference_id: conference_id).update(**params)
    end

    it "sends a request" do
      subject
      expect(a_request(:put, url)).to have_been_made
    end

    it_behaves_like "returns_conference_object"
    it_behaves_like "returns_not_found_error"
  end

  describe "#delete" do
    let(:conference_id) { "5576502892" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/conferences/delete.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_conference(conference_id: conference_id).delete
    end

    it "sends a request" do
      subject
      expect(a_request(:delete, url)).to have_been_made
    end

    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.id).to eq "5576502892"

      expect(subject.running?).to eq false
      expect(subject.stopped?).to eq false
    end

    it_behaves_like "returns_not_found_error"
  end

  describe "#run" do
    let(:conference_id) { "5576502892" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/run?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/conferences/run.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_conference(conference_id: conference_id).run
    end

    it "sends a request" do
      subject
      expect(a_request(:post, url)).to have_been_made
    end

    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.state).to eq "running"

      expect(subject.running?).to eq true
      expect(subject.stopped?).to eq false
    end

    it_behaves_like "returns_not_found_error"
  end

  describe "#stop" do
    let(:conference_id) { "5576502892" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/stop?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/conferences/stop.json") }

    before { stub_request(:any, //).to_return(body: body) }

    subject do
      client.by_conference(conference_id: conference_id).stop
    end

    it "sends a request" do
      subject
      expect(a_request(:post, url)).to have_been_made
    end

    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.state).to eq "stopped"

      expect(subject.running?).to eq false
      expect(subject.stopped?).to eq true
    end

    it_behaves_like "returns_not_found_error"
  end
end
