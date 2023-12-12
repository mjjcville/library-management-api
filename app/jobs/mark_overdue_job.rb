# A job that runs nightly to mark any books that were due the da
class MarkOverdueJob < ApplicationJob
  queue_as :default

  def perform(*args)
    
    book_copies_overdue = BookCopy.past_due_date.includes(:borrower_record)

    book_copies_overdue.each do | copy |
      borrower_record = copy.borrower_record
      borrower_record.update(status: "overdue")
      Fee.create!(fee_amount: 1.00, status: "accruing",borrower_record_id: borrower_record.id)
      copy.update(status: "available")
    end
  end
end
