require 'rails_helper'

describe Search do
  subject { QueryParser.parse(string) }

  describe ".parse" do
    context "correct string" do
      let(:string) { " a    b  c d  e " }

      it "should strip, squeeze and gsub a string" do
        expect(subject).to eq("a+b+c+d+e")
      end
    end

    context "nil" do
      let(:string) { nil }

      it "should return nil" do
        expect(subject).to eq(nil)
      end
    end
  end
end