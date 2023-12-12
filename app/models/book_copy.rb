class BookCopy < ApplicationRecord
  belongs_to :library
  belongs_to :book
  has_one :borrower_records

  enum :status, [
    :available,
    :checked_out
  ], validate: true

  scope :by_due_date, -> { order(due_date: :asc) }
  scope :past_due_date, -> { where('due_date < ?', DateTime.now.beginning_of_day)}
end