class Borrower < ApplicationRecord
  belongs_to :library
  belongs_to :user
  has_many :checkout_activity

  validates :join_date, presence: true

  enum :status, [
    :active,
    :quit
  ], validate: true
end
