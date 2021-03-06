require 'spec_helper'

describe Rrod do

  it "adds a configure method to the Rrod module" do
    expect(Rrod).to respond_to(:configure)
  end

  it "yields the configuration to the block given to config" do
    Rrod.configure do |config|
      config.pb_port = 123456
    end
  end

  it "adds a configuration object to the Rrod module" do
    expect(Rrod.configuration).to be_a Rrod::Configuration
  end

end

describe Rrod::Configuration do

  let(:config) { described_class.new }

  describe "defaults" do
    it "will use spec/support/test_server.yml for the test_server_yml" do
      expect(config.test_server_yml).to match('spec/support/test_server.yml')
    end
  end

  describe "client" do
    it "creates a client based on its options" do
      config.pb_port = 123456
      expect(Riak::Client).to receive(:new).with(pb_port: 123456, protocol: 'pbc')
      config.client
    end

    it "will not create a client if one exists" do
      config.client = Riak::Client.new
      expect(Riak::Client).not_to receive(:new)
      config.client
    end
  end

  describe "attributes" do
    %w[http_port pb_port protocol client test_server_yml
       test_server_search_startup_timeout nodes].each do |attribute|
      it "allows configuration of #{attribute}" do
        expect(config).to respond_to attribute
        expect(config).to respond_to "#{attribute}="
      end
    end
  end

end
