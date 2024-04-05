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

  shared_examples "returns_record_object" do
    it "returns success" do
      expect(subject.success?).to eq true

      expect(subject).to be_kind_of TrueConf::Response
      expect(subject.name).to eq "record.mkv"
      expect(subject.size).to eq "8487982"
      expect(subject.created).to eq 1_603_399_762
      expect(subject.download_url).to eq "https://trueconf.teachbase.ru/api/v3/conferences/4411982490/records/record.mkv/download"
    end
  end

  shared_examples "returns_record_list_object" do
    it "returns success" do
      expect(subject).to be_kind_of Array
      expect(subject.first).to be_kind_of TrueConf::Entity::Record
      expect(subject.first.name).to eq "record.mkv"
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
    let(:record_id) { "record.mkv" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/records/#{record_id}?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/records/record.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject do
      client.by_conference(conference_id: conference_id)
        .by_record(id: record_id)
        .get
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_record_object"
    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#all" do
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/records?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/records/list.json") }

    before { stub_request(:any, //).to_return(body: body) }
    subject do
      client.by_conference(conference_id: conference_id)
        .records
        .all
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_record_list_object"
    it_behaves_like "returns_forbidden_error"
  end

  describe "#download" do
    let(:record_id) { "record.mkv" }
    let(:url) { "https://trueconf.local/api/v3.1/conferences/#{conference_id}/records/#{record_id}/download?access_token=access_token" }
    let(:body) { File.read("spec/fixtures/records/example.mp4") }

    before { stub_request(:any, //).to_return(body: body) }
    subject do
      client.by_conference(conference_id: conference_id)
        .by_record(id: record_id)
        .download
    end

    it "sends a request" do
      subject
      expect(a_request(:get, url)).to have_been_made
    end

    it_behaves_like "returns_not_found_error"
    it_behaves_like "returns_forbidden_error"
  end
end
