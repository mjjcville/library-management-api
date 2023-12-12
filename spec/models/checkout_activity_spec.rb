# spec/models/borrower_record_spec.rb
require 'rails_helper'

describe BorrowerRecord, type: :model do
  let(:checkout_date) { DateTime.now }
  let(:test_book_copy) { create :book_copy}
  let(:test_borrower) { create :borrower }

  it 'is valid with a checkout date, status, borrower, book_copy and status' do
    borrower_record = BorrowerRecord.new( checkout_date: checkout_date, status: "borrowing", borrower_id: test_borrower.id, book_copy_id: test_book_copy.id )
    expect(borrower_record).to be_valid
  end

  it 'is valid when status is not set because of default' do
    borrower_record = BorrowerRecord.new( checkout_date: checkout_date,  borrower_id: test_borrower.id, book_copy_id: test_book_copy.id )
    expect(borrower_record).to be_valid
  end

  it 'is invalid when book_copy is missing' do
    borrower_record = BorrowerRecord.new( checkout_date: checkout_date, status: "borrowing", borrower_id: test_borrower.id)
    expect(borrower_record).to be_invalid
  end

  it 'is invalid when borrower is missing' do
    borrower_record = BorrowerRecord.new( checkout_date: checkout_date, status: "borrowing", book_copy_id: test_book_copy.id )
    expect(borrower_record).to be_invalid
  end

  it 'is invalid when checkout date is missing' do
    borrower_record = BorrowerRecord.new( status: "borrowing", borrower_id: test_borrower.id, book_copy_id: test_book_copy.id )
    expect(borrower_record).to be_invalid
  end
end