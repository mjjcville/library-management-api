# spec/models/checkout_activity_spec.rb
require 'rails_helper'

describe CheckoutActivity, type: :model do
    let(:checkout_date) { DateTime.now }
    let(:test_book_copy) { create :book_copy}
    let(:test_patron_registration) { create :patron_registration }

    it 'is valid with a checkout date, status, patron_registration, book_copy and status' do
        checkout_activity = CheckoutActivity.new( checkout_date: checkout_date, status: "borrowing", patron_registration_id: test_patron_registration.id, book_copy_id: test_book_copy.id )
        expect(checkout_activity).to be_valid
    end

    it 'is valid when status is not set because of default' do
        checkout_activity = CheckoutActivity.new( checkout_date: checkout_date,  patron_registration_id: test_patron_registration.id, book_copy_id: test_book_copy.id )
        expect(checkout_activity).to be_valid
    end

    it 'is invalid when book_copy is missing' do
        checkout_activity = CheckoutActivity.new( checkout_date: checkout_date, status: "borrowing", patron_registration_id: test_patron_registration.id)
        expect(checkout_activity).to be_invalid
    end

    it 'is invalid when patron_registration is missing' do
        checkout_activity = CheckoutActivity.new( checkout_date: checkout_date, status: "borrowing", book_copy_id: test_book_copy.id )
        expect(checkout_activity).to be_invalid
    end

    it 'is invalid when checkout date is missing' do
        checkout_activity = CheckoutActivity.new( status: "borrowing", patron_registration_id: test_patron_registration.id, book_copy_id: test_book_copy.id )
        expect(checkout_activity).to be_invalid
    end
end