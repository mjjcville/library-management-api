# spec/models/library_spec.rb

require 'rails_helper'

describe Library, type: :model do
  it 'is valid with a name' do
    library = Library.new(name: "Test Library")
    expect(library).to be_valid
  end

  it 'is invalid without a  name' do
    library = Library.new()
    expect(library).to be_invalid
  end
end