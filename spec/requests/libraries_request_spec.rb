# spec/controllers/libraries_request_spec.rb

require 'rails_helper'

describe "Library Request", type: :request do
  before { allow_any_instance_of(Api::V1::LibrariesController).to receive(:authenticate_user!).and_return(true) }
  
  describe 'POST create' do
    let!(:test_library_1) { create(:library) }
    let(:invalid_params) { { library: {description: "Just a test description"} } }
    let(:valid_params_existing_library) { { library: {name: test_library_1.name} } }
    let(:valid_full_params) { {
      library: {
        name: "Test Library Full Params", 
        description: "Just a test description",
        address_line_1: "100 Main St",
        address_line_2: "Suite 100",
        city: "Test City",
        state: "Test State",
        zip: "Test Zip"
      } }
    }
    let(:valid_partial_params) { {library: {name: "Test Library Partial Params"} } }

    it "finds an existing library with the given params and returns a 200" do
      library_count = Library.count
      post '/api/v1/libraries', params: valid_params_existing_library.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response.status).to eql(200)
      expect(library_count).to eq(Library.count)  #to prove no new libraries created
    end

    it "creates a new library with partial params and returns a 201" do
      post '/api/v1/libraries', params: valid_partial_params

      expect(response.status).to eql(201)
      library = Library.last
      expect(library).to be_truthy
    end


    it "creates a new library with full params and returns a 201" do
      post '/api/v1/libraries', params: valid_full_params.to_json, headers: { 'Content-Type': 'application/json' }

      expect(response.status).to eql(201)
      library = Library.last
      expect(library).to be_truthy
      expect(library.name).to eql(valid_full_params[:library][:name])
      expect(library.description).to eql(valid_full_params[:library][:description])
      expect(library.address_line_1).to eql(valid_full_params[:library][:address_line_1])
      expect(library.address_line_2).to eql(valid_full_params[:library][:address_line_2])
      expect(library.city).to eql(valid_full_params[:library][:city])
      expect(library.state).to eql(valid_full_params[:library][:state])
      expect(library.zip).to eql(valid_full_params[:library][:zip])
    end

    it "fails to create a library with invalid params and returns a 422" do
      post '/api/v1/libraries', params: invalid_params.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response.status).to eql(422)
      library = Library.find_by(description: invalid_params[:library][:description])
      expect(library).to be_falsey
    end
  end
end
