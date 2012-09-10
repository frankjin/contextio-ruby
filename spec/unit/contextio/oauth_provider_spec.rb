require 'spec_helper'
require 'contextio/oauth_provider'

describe ContextIO::OAuthProvider do
  let(:api) { double('API') }

  describe ".new" do
    subject { ContextIO::OAuthProvider.new(api, resource_url: 'bar', baz: 'bot') }

    it "takes an api handle" do
      expect(subject.api).to eq(api)
    end

    it "assigns instance variables for hash arguments" do
      expect(subject.instance_variable_get('@resource_url')).to eq('bar')
      expect(subject.instance_variable_get('@baz')).to eq('bot')
    end

    context "with a provider_consumer_key passed in" do
      it "doesn't raise an error" do
        expect { ContextIO::OAuthProvider.new(api, provider_consumer_key: 'foo') }.to_not raise_error
      end
    end

    context "with a resource_url passed in" do
      it "doesn't raise an error" do
        expect { ContextIO::OAuthProvider.new(api, resource_url: 'foo') }.to_not raise_error
      end
    end

    context "with neither a provider_consumer_key nor a resource_url passed in" do
      it "raises an ArgumentError" do
        expect { ContextIO::OAuthProvider.new(api, foo: 'bar') }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#resource_url" do
    context "when input at creation" do
      subject { ContextIO::OAuthProvider.new(api, resource_url: 'http://example.com') }

      it "uses the input URL" do
        expect(subject.resource_url).to eq('http://example.com')
      end
    end

    context "when not input at creation" do
      subject { ContextIO::OAuthProvider.new(api, provider_consumer_key: '1234') }

      it "builds its own URL" do
        expect(subject.resource_url).to eq('oauth_providers/1234')
      end
    end
  end
end