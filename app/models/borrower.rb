class Borrower < ApplicationRecord
  belongs_to :library
  belongs_to :library_user
  has_many :borrower_records

  validates :join_date, presence: true

  enum :status, [
    :active,
    :quit
  ], validate: true
end
