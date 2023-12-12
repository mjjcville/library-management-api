# spec/controllers/borrowers_request_spec.rb

require 'rails_helper'

describe "Borrowers Request", type: :request do
  before { allow_any_instance_of(Api::V1::BorrowersController).to receive(:authenticate_user!).and_return(true) }
  
  describe 'POST create' do
    let!(:test_library_1) { create(:library) }
    let!(:test_library_2) { create(:library) }
    let!(:test_library_user) { create(:library_user) }
    let!(:test_borrower) { create(:borrower, status: "active", library_id: test_library_1.id, library_user_id: test_library_user.id )  }
    let(:invalid_params) { { borrower: {first_name: "John"}} }

    let(:valid_full_params_existing_user_borrower) { {
      borrower: {
        library_id: test_library_1.id,
        first_name: test_library_user.first_name, 
        last_name: test_library_user.last_name,
        credit_card_number: test_library_user.credit_card_number,
        credit_card_expiration: test_library_user.credit_card_expiration,
        credit_card_security_code: test_library_user.credit_card_security_code
      } }
    }
    let(:valid_full_params_existing_library_user_only) { {
      borrower: {
        library_id: test_library_2.id,
        first_name: test_library_user.first_name, 
        last_name: test_library_user.last_name,
        credit_card_number: test_library_user.credit_card_number,
        credit_card_expiration: test_library_user.credit_card_expiration,
        credit_card_security_code: test_library_user.credit_card_security_code
      } }
    }
    let(:valid_full_params_new_user) { {
        borrower: {
        library_id: test_library_2.id,
        first_name: "John", 
        last_name: "Test",
        credit_card_number: "5555 6666 7777 8888",
        credit_card_expiration: "01/29",
        credit_card_security_code: "888"
      } }
    }
      
    it "finds an existing borrower and user returns a 200:ok" do
      post '/api/v1/borrowers', params: valid_full_params_existing_user_borrower.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response.status).to eql(200)
      borrower_id = JSON.parse(response.body)["borrower_id"]

      borrower = Borrower.find(borrower_id)

      expect(borrower).to be_truthy
      expect(borrower.library_id).to eql(test_borrower.library_id)
      expect(borrower.library_user_id).to eql(test_borrower.library_user_id)

      expect(borrower.library_user.first_name).to eql(test_library_user.first_name)
      expect(borrower.library_user.last_name).to eql(test_library_user.last_name)
      expect(borrower.library_user.credit_card_number).to eql(test_library_user.credit_card_number)
      expect(borrower.library_user.credit_card_expiration).to eql(test_library_user.credit_card_expiration)
      expect(borrower.library_user.credit_card_security_code).to eql(test_library_user.credit_card_security_code)
    end

    it "creates a new borrower for an existing user returns a 201:created" do
      post '/api/v1/borrowers', params: valid_full_params_existing_library_user_only.to_json, headers: { 'Content-Type': 'application/json' }

      expect(response.status).to eql(201)
      borrower_id = JSON.parse(response.body)["borrower_id"]

      borrower = Borrower.find(borrower_id)

      expect(borrower).to be_truthy
      expect(borrower.library_id).to eql(test_library_2.id)
      expect(borrower.library_user_id).to eql(test_borrower.library_user_id)

      expect(borrower.library_user.first_name).to eql(test_library_user.first_name)
      expect(borrower.library_user.last_name).to eql(test_library_user.last_name)
      expect(borrower.library_user.credit_card_number).to eql(test_library_user.credit_card_number)
      expect(borrower.library_user.credit_card_expiration).to eql(test_library_user.credit_card_expiration)
      expect(borrower.library_user.credit_card_security_code).to eql(test_library_user.credit_card_security_code)
    end

    it "creates a new borrower and new user returns a 201:created" do
      post '/api/v1/borrowers', params: valid_full_params_new_user.to_json, headers: { 'Content-Type': 'application/json' }

      expect(response.status).to eql(201)
      borrower_id = JSON.parse(response.body)["borrower_id"]

      borrower = Borrower.find(borrower_id)
      library_user = LibraryUser.last

      expect(borrower).to be_truthy
      expect(borrower.library_id).to eql(test_library_2.id)
      expect(borrower.library_user_id).to eql(library_user.id)

      expect(borrower.library_user.first_name).to eql(library_user.first_name)
      expect(borrower.library_user.last_name).to eql(library_user.last_name)
      expect(borrower.library_user.credit_card_number).to eql(library_user.credit_card_number)
      expect(borrower.library_user.credit_card_expiration).to eql(library_user.credit_card_expiration)
      expect(borrower.library_user.credit_card_security_code).to eql(library_user.credit_card_security_code)
    end
  end
end