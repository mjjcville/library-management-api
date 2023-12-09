# spec/models/library_spec.rb

require 'rails_helper'

describe PatronRegistration, type: :model do
    let(:test_library) { create :library}
    let(:test_patron) { create :patron}
    let(:join_date) { DateTime.now }

    it 'is valid with a join date, a status, a library and a patron' do
        patron_registration = PatronRegistration.new(join_date: join_date, status: "active", library_id: test_library.id, patron_id: test_patron.id )
        expect(patron_registration).to be_valid
    end

    it 'is valid without a status because a default is set' do
        patron_registration = PatronRegistration.new(join_date: join_date, library_id: test_library.id, patron_id: test_patron.id )
        expect(patron_registration).to be_valid
    end

    it 'is invalid without a join date' do
        patron_registration = PatronRegistration.new( status: "active", library_id: test_library.id, patron_id: test_patron.id )
        expect(patron_registration).to be_invalid
    end

    it 'is invalid without a library' do
        patron_registration = PatronRegistration.new(join_date: join_date,  status: "active", patron_id: test_patron.id )
        expect(patron_registration).to be_invalid
    end

    it 'is invalid without a patron' do
        patron_registration = PatronRegistration.new(join_date: join_date,  status: "active", library_id: test_library.id )
        expect(patron_registration).to be_invalid
    end
end