require 'rails_helper'

describe Search do
  let(:query) { "" }
  let(:search) { Search.new(query) }

  subject { search }

  describe ".initialize" do
    it "should assign query" do
      expect(search.query).to eq(query)
    end
  end

  describe "#results" do
    subject { VCR.use_cassette('search') { search.results } }

    context "full results" do
      let(:query) { "managing+money" }

      let(:en_result) { OpenStruct.new(url: "https://www.moneyadviceservice.org.uk/en/articles/beginners-guide-to-managing-your-money", title: "Beginner's guide to managing your money - Money Advice Service") }
      let(:cy_result) { OpenStruct.new(url: "https://www.moneyadviceservice.org.uk/cy/articles/canllaw-syml-i-reoli-eich-arian", title: "Canllaw syml i reoli eich arian") }
      let(:response) { OpenStruct.new(english: en_result, welsh: cy_result) }

      it { expect(subject).to eq(response) }
    end

    context "no results" do
      let(:query) { "aaaaaa" }
      let(:response) { OpenStruct.new(english: nil, welsh: nil) }

      it { expect(subject).to eq(response) }
    end
  end
end
