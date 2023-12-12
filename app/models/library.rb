class Library < ApplicationRecord
  has_many :book_copy
  has_many :borrower

  validates :name, presence: true
end
