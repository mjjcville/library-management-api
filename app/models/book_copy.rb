class BookCopy < ApplicationRecord
  belongs_to :library
  belongs_to :book
  has_many :borrower_record

  enum :status, [
    :available,
    :checked_out
  ], validate: true

  scope :by_due_date, -> { order(due_date: :asc) }
end