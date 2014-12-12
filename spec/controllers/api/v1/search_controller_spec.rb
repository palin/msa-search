require 'rails_helper'

describe Api::V1::SearchController do

  describe "GET index" do
    subject { get :index, format: :json }

    its(:status) { should == 200 }
  end
end