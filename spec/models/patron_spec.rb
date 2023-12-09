# spec/models/library_spec.rb

require 'rails_helper'

describe Patron, type: :model do
    it 'is valid with first and last name, credit card info' do
        patron = Patron.new(first_name: "Test", last_name: "Patron", credit_card_number: "1111-2222-3333-4444", credit_card_expiration: "01/30",credit_card_security_code: "999")
        expect(patron).to be_valid
    end

    it 'is invalid without a first name' do
        patron = Patron.new(last_name: "Patron", credit_card_number: "1111-2222-3333-4444", credit_card_expiration: "01/30",credit_card_security_code: "999")
        expect(patron).to be_invalid
    end

    it 'is invalid without a last name' do
        patron = Patron.new(first_name: "Test",  credit_card_number: "1111-2222-3333-4444", credit_card_expiration: "01/30",credit_card_security_code: "999")
        expect(patron).to be_invalid
    end

    it 'is invalid without a credit_card_number' do
        patron = Patron.new( first_name: "Test", last_name: "Patron",  credit_card_expiration: "01/30",credit_card_security_code: "999")
        expect(patron).to be_invalid
    end

    it 'is invalid without a credit card expiration' do
        patron = Patron.new(first_name: "Test", last_name: "Patron", credit_card_number: "1111-2222-3333-4444", credit_card_security_code: "999")
        expect(patron).to be_invalid
    end

    it 'is invalid without a credit card security code' do
        patron = Patron.new(first_name: "Test", last_name: "Patron", credit_card_number: "1111-2222-3333-4444", credit_card_expiration: "01/30")
        expect(patron).to be_invalid
    end
end