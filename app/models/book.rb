class Book < ApplicationRecord
  belongs_to :author
  has_many :book_copy

  validates :isbn, presence: true
  validates :title, presence: true

end
