# spec/controllers/borrowers_request_spec.rb

require 'rails_helper'

describe "Borrowers Request", type: :request do
describe 'POST create' do
let!(:test_library_1) { create(:library) }
let!(:test_library_2) { create(:library) }
let!(:test_user) { create(:user) }
let!(:test_borrower) { create(:borrower, status: "active", library_id: test_library_1.id, user_id: test_user.id )  }
let(:invalid_params) { { borrower: {first_name: "John"}} }

let(:valid_full_params_existing_user_borrower) { {
borrower: {
library_id: test_library_1.id,
first_name: test_user.first_name, 
last_name: test_user.last_name,
credit_card_number: test_user.credit_card_number,
credit_card_expiration: test_user.credit_card_expiration,
credit_card_security_code: test_user.credit_card_security_code
} }
}
let(:valid_full_params_existing_user_only) { {
borrower: {
library_id: test_library_2.id,
first_name: test_user.first_name, 
last_name: test_user.last_name,
credit_card_number: test_user.credit_card_number,
credit_card_expiration: test_user.credit_card_expiration,
credit_card_security_code: test_user.credit_card_security_code
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
expect(borrower.user_id).to eql(test_borrower.user_id)

expect(borrower.user.first_name).to eql(test_user.first_name)
expect(borrower.user.last_name).to eql(test_user.last_name)
expect(borrower.user.credit_card_number).to eql(test_user.credit_card_number)
expect(borrower.user.credit_card_expiration).to eql(test_user.credit_card_expiration)
expect(borrower.user.credit_card_security_code).to eql(test_user.credit_card_security_code)

end

it "creates a new borrower for an existing user returns a 201:created" do
post '/api/v1/borrowers', params: valid_full_params_existing_user_only.to_json, headers: { 'Content-Type': 'application/json' }

expect(response.status).to eql(201)
borrower_id = JSON.parse(response.body)["borrower_id"]

borrower = Borrower.find(borrower_id)

expect(borrower).to be_truthy
expect(borrower.library_id).to eql(test_library_2.id)
expect(borrower.user_id).to eql(test_borrower.user_id)

expect(borrower.user.first_name).to eql(test_user.first_name)
expect(borrower.user.last_name).to eql(test_user.last_name)
expect(borrower.user.credit_card_number).to eql(test_user.credit_card_number)
expect(borrower.user.credit_card_expiration).to eql(test_user.credit_card_expiration)
expect(borrower.user.credit_card_security_code).to eql(test_user.credit_card_security_code)

end

it "creates a new borrower and new user returns a 201:created" do
post '/api/v1/borrowers', params: valid_full_params_new_user.to_json, headers: { 'Content-Type': 'application/json' }

expect(response.status).to eql(201)
borrower_id = JSON.parse(response.body)["borrower_id"]

borrower = Borrower.find(borrower_id)
user = User.last

expect(borrower).to be_truthy
expect(borrower.library_id).to eql(test_library_2.id)
expect(borrower.user_id).to eql(user.id)

expect(borrower.user.first_name).to eql(user.first_name)
expect(borrower.user.last_name).to eql(user.last_name)
expect(borrower.user.credit_card_number).to eql(user.credit_card_number)
expect(borrower.user.credit_card_expiration).to eql(user.credit_card_expiration)
expect(borrower.user.credit_card_security_code).to eql(user.credit_card_security_code)

end
end
end