class BorrowerRecord < ApplicationRecord
  belongs_to :borrower
  belongs_to :book_copy
  has_many :fees

  validates :checkout_date, presence: true
 
  enum :status, [
    :borrowing,
    :overdue,
    :returned
  ], validate: true

end
