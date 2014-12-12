require 'rails_helper'

describe Api::V1::SearchController do
  render_views

  let(:json) { MultiJson.load(subject.body) }
  let(:results) { json['results'] }

  describe "GET index" do
    subject { get :index, format: :json, query: query }

    context "with correct query" do
      let(:query) { "budget plan" }
      let(:en_result) { double(title: 'en title', url: 'en url') }

      context "full response results" do
        let(:cy_result) { double(title: 'cy title', url: 'cy url') }
        let(:search_result) { double(english: en_result, welsh: cy_result) }

        before { expect_any_instance_of(Search).to receive(:results).and_return(search_result) }

        it "should have OK status" do
          expect(subject.status).to eq(200)
        end

        it "should have 2 results" do
          expect(results.length).to eq(2)
        end

        context "should have proper json structure" do
          context "english result" do
            let(:english_result) { results['english'] }

            it { expect(english_result['title']).to eq("en title") }
            it { expect(english_result['url']).to eq("en url") }
          end

          context "welsh result" do
            let(:welsh_result) { results['welsh'] }

            it { expect(welsh_result['title']).to eq("cy title") }
            it { expect(welsh_result['url']).to eq("cy url") }
          end
        end
      end

      context "half response results" do
        let(:search_result) { double(english: en_result, welsh: nil) }

        before { expect_any_instance_of(Search).to receive(:results).and_return(search_result) }

        it "should have OK status" do
          expect(subject.status).to eq(200)
        end

        it "should have 1 results" do
          expect(results.length).to eq(1)
        end

        context "should have proper json structure" do
          context "english result" do
            let(:english_result) { results['english'] }

            it { expect(english_result['title']).to eq("en title") }
            it { expect(english_result['url']).to eq("en url") }
          end
        end
      end

      context "no response results" do
        before { expect_any_instance_of(Search).to receive(:results).and_return(OpenStruct.new) }

        it "should have OK status" do
          expect(subject.status).to eq(200)
        end

        it "should have empty body" do
          expect(results).to eq(nil)
        end
      end
    end

    context "with empty query" do
      let(:query) { "" }

      it "should have BAD REQUEST status" do
        expect(subject.status).to eq(400)
      end
    end

    context "without query" do
      subject { get :index, format: :json }

      it "should have BAD REQUEST status" do
        expect(subject.status).to eq(400)
      end
    end
  end
end
