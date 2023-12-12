class Library < ApplicationRecord
  has_many :book_copies
  has_many :borrowers

  validates :name, presence: true
end
