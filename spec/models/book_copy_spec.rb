# spec/models/book_copy_spec.rb
require 'rails_helper'

describe BookCopy, type: :model do
    let(:test_library) { create :library}
    let(:test_book) { create :book}

    it 'is valid with a library, book and status' do
        book_copy = BookCopy.new(status: "available", library_id: test_library.id, book_id: test_book.id)
        expect(book_copy).to be_valid
    end

    it 'is valid when status is not set because it defaults' do
        book_copy = BookCopy.new(library_id: test_library.id, book_id: test_book.id)
        expect(book_copy).to be_valid
    end

    it 'is invalid without a library' do
        book_copy = BookCopy.new( book_id: test_book.id )
        expect(book_copy).to be_invalid
    end

    it 'is invalid without a book' do
        book_copy = BookCopy.new( library_id: test_library.id)
        expect(book_copy).to be_invalid
    end

end