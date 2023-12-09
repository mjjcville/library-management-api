class CheckoutActivity < ApplicationRecord
  belongs_to :patron_registration
  belongs_to :book_copy

  validates :checkout_date, presence: true
  
  enum :status, [
        :borrowing,
        :overdue,
        :returned
    ], validate: true
end
