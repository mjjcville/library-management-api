# spec/controllers/book_copies_request_spec.rb

require 'rails_helper'

current_date = DateTime.now
yesterday = current_date - 1.day
next_week = current_date + 1.week

describe "Book Copies Request", type: :request do
  let!(:test_library_1) { create(:library) }
  let!(:test_library_2) { create(:library) }
  let!(:book_1) { create(:book) }
  let!(:book_copy_1) { create(:book_copy, library_id: test_library_1.id, book_id: book_1.id) }
  let!(:book_copy_2) { create(:book_copy, library_id: test_library_2.id, book_id: book_1.id) }
  let!(:borrower) { create(:borrower, library_id: test_library_1.id) }

  describe 'POST create' do
    let!(:valid_checkout) { {
        checkout_info: {
        borrower_id: borrower.id
      }
    } }
    let!(:invalid_checkout) { {
        checkout_info: {
      }
    } }
    let!(:invalid_checkout_mismatched_borrower) { {
      checkout_info: {
        borrower_id: borrower.id
      }
    } }
    it 'should add a checkout record for the given borrower and change the status on the copy to unavailable' do
      post "/api/v1/book_copies/#{book_copy_1.id}/checkout", params: valid_checkout.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response.status).to eql(200)
      borrower_record = BorrowerRecord.last 
      expect(borrower_record.book_copy_id).to eql(book_copy_1.id)
      expect(borrower_record.status).to eql("borrowing")
      book_copy_1.reload
      expect(book_copy_1.status).to eql("checked_out")
    end

    it 'should fail if the borrower information is missing' do
      post "/api/v1/book_copies/#{book_copy_1.id}/checkout", params: invalid_checkout.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response.status).to eql(422)
    end

    it 'should fail if the borrower is not associated with the same library as the book copy'  do
      post "/api/v1/book_copies/#{book_copy_2.id}/checkout", params: invalid_checkout_mismatched_borrower.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response.status).to eql(422)
    end
  end

  describe 'PATCH update' do
    it 'should update both the borrower record and the book copy to indicate a return' do 
    end

    it 'should fail if the borrower record cannot be found' do
    end

    it 'should fail if the borrower has too many records for the same book' do
    end

  end
end