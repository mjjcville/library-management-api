class Fee < ApplicationRecord
  belongs_to :borrower_record

  enum :status, [
    :accruing,
    :paid
  ], validate: true
end