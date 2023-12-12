# spec/models/author_spec.rb

require 'rails_helper'

describe Author, type: :model do
  it 'is valid with both a first and last name' do
    author = Author.new(first_name: "Test", last_name: "Author")
    expect(author).to be_valid
  end

  it 'is invalid without a first name or a last name' do
    author = Author.new()
    expect(author).to be_invalid
  end

  it 'is invalid without a first name, but has a last name' do
    author = Author.new(last_name: "Author")
    expect(author).to be_invalid
  end

  it 'is invalid without a last name, but has a first name' do
    author = Author.new(first_name: "Test")
    expect(author).to be_invalid
  end
end