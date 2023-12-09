# spec/models/book_spec.rb
require 'rails_helper'

describe Book, type: :model do
    let(:test_author) { create :author}

    it 'is valid with an author, isbn, and title' do
        book = Book.new(author_id: test_author.id, isbn: "isbn:11111", title: "Test Title")
        expect(book).to be_valid
    end

    it 'is invalid when title is not set' do
        book = Book.new(author_id: test_author.id, isbn: "isbn:11111", )
        expect(book).to be_invalid
    end

    it 'is invalid when isbn is not set' do
        book = Book.new( author_id: test_author.id,title: "Test Title" )
        expect(book).to be_invalid
    end

    it 'is invalid when author is not set' do
        book = Book.new( isbn: "isbn:11111", title: "Test Title" )
        expect(book).to be_invalid
    end
end