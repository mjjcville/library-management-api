class BorrowerRecord < ApplicationRecord
  belongs_to :borrower
  belongs_to :book_copy

  validates :checkout_date, presence: true

  enum :status, [
    :borrowing,
    :overdue,
    :returned
  ], validate: true
end
