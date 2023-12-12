# spec/controllers/books_request_spec.rb

require 'rails_helper'

current_date = DateTime.now
yesterday = current_date - 1.day
next_week = current_date + 1.week

describe "Borrowers Request", type: :request do
let!(:test_library_1) { create(:library) }
let!(:test_library_2) { create(:library) }
let!(:book_1) { create(:book)}

describe 'POST create' do
let!(:existing_book_no_copies) { {
book: {
library_id: test_library_1.id,
isbn: book_1.isbn,
title: book_1.title, 
author_first_name: book_1.author.first_name,
author_last_name: book_1.author.last_name
}
} }
let!(:new_book_no_copies) { {
book: {
library_id: test_library_1.id,
isbn: "Generic Test ISBN",
title: "Generic Test Title", 
author_first_name: book_1.author.first_name,
author_last_name: book_1.author.last_name
}
} }

it 'should add a book to a library' do
initial_copy_count = BookCopy.count 
post '/api/v1/books', params: existing_book_no_copies.to_json, headers: { 'Content-Type': 'application/json' }
expect(response.status).to eql(201)
current_copy_count = BookCopy.count
expect(current_copy_count).to eql(initial_copy_count + 1)
end

it 'should add a new book to a library' do
initial_copy_count = BookCopy.count 
initial_book_count = Book.count

post '/api/v1/books', params: new_book_no_copies.to_json, headers: { 'Content-Type': 'application/json' }
expect(response.status).to eql(201)

current_copy_count = BookCopy.count
current_book_count = Book.count
expect(current_copy_count).to eql(initial_copy_count + 1)
expect(current_book_count).to eql(initial_book_count + 1)
end
end

describe 'GET index' do
let!(:copy_1) { create(:book_copy, library_id: test_library_1.id, book_id: book_1.id)}
let!(:copy_2) { create(:book_copy, library_id: test_library_1.id, book_id: book_1.id, status: "checked_out", due_date: next_week )}
let!(:copy_3) { create(:book_copy, library_id: test_library_2.id, book_id: book_1.id)}
let!(:copy_4) { create(:book_copy, library_id: test_library_2.id, book_id: book_1.id, status: "checked_out", due_date: next_week )}

let(:valid_global_params) { { book: { title: book_1.title, global_search: true} } }
let(:valid_singular_params) { { book: { title: book_1.title, library_id: test_library_1.id} } }

let(:invalid_params) { { borrower: { first_name: "John"} } }

it 'should return a list of books by title from all libraries' do
get '/api/v1/books', params: valid_global_params
expect(response.status).to eql(200)
booklist= JSON.parse(response.body)["booklist"]
expect(booklist.size).to eql(4)
end

it 'should return a list of books by title, availability/due_date from one library ' do
get '/api/v1/books', params: valid_singular_params
expect(response.status).to eql(200)
booklist= JSON.parse(response.body)["booklist"]
expect(booklist.size).to eql(2)
end
end
end

