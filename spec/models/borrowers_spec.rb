# spec/models/library_spec.rb

require 'rails_helper'

describe Borrower, type: :model do
  let(:test_library) { create :library}
  let(:library_user) { create :library_user}
  let(:join_date) { DateTime.now }

  it 'is valid with a join date, a status, a library and a patron' do
    borrower = Borrower.new(join_date: join_date, status: "active", library_id: test_library.id, library_user_id: library_user.id )
    expect(borrower).to be_valid
  end

  it 'is valid without a status because a default is set' do
    borrower = Borrower.new(join_date: join_date, library_id: test_library.id, library_user_id: library_user.id )
    expect(borrower).to be_valid
  end

  it 'is invalid without a join date' do
    borrower = Borrower.new( status: "active", library_id: test_library.id, library_user_id: library_user.id )
    expect(borrower).to be_invalid
  end

  it 'is invalid without a library' do
    borrower = Borrower.new(join_date: join_date,  status: "active", library_user_id: library_user.id )
    expect(borrower).to be_invalid
  end

  it 'is invalid without a patron' do
    borrower = Borrower.new(join_date: join_date,  status: "active", library_id: test_library.id )
    expect(borrower).to be_invalid
  end
end