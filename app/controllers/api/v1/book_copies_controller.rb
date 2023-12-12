include Devise::Controllers::Helpers


class Api::V1::BookCopiesController < ApplicationController
  before_action :authenticate_user!

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::ActiveRecordError, with: :general_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :find_book_copy
  before_action :find_borrower
  
  def checkout
    current_date = DateTime.now.beginning_of_day
    next_week = current_date + 1.week 
    
    #Verify borrower has access to book copy's library
    if @borrower.library_id != @book_copy.library_id
      render json: { error: 'Please see a librarian. There is a problem with this borrower record.' }, status: :unprocessable_entity
      return
    end

    #Verify that borrower has no unpaid fees, for any book copies
    unpaid_fees = false
    @borrower.borrower_records.each do | borrower_record |
      if borrower_record.fees.any?
        unpaid_fees = true
        break
      end
    end

    if unpaid_fees
      render json: { error: 'Please see a librarian. The borrower has unpaid fees.' }, status: :unprocessable_entity
      return
    end

    #Find any existing borrower record for this book copy
    borrower_records = BorrowerRecord.where(book_copy_id: @book_copy.id, status: "borrowing", borrower_id: @borrower.id )
    
    if borrower_records.any?
      render json: { error: 'Please see a librarian. There is a problem with this borrower record.' }, status: :unprocessable_entity
    else
      borrower_record = BorrowerRecord.new
      borrower_record.checkout_date = current_date
      borrower_record.status = "borrowing"
      borrower_record.borrower_id = checkout_params[:borrower_id]
      
      @book_copy.due_date = next_week
      @book_copy.status = "checked_out"
      
      borrower_record.book_copy_id = @book_copy.id

      #save! raises an error, which will be caught in the rescue methods
      @book_copy.save!
      borrower_record.save!
    
      render json: {message: "#{@book_copy.book.title} successfully checked out" }, status: :ok
    end
  end

  def checkin
    current_date = DateTime.now

    #Find the existing borrower record for this book copy
    borrower_records = BorrowerRecord.where(book_copy_id: @book_copy.id, status: "borrowing", borrower_id: @borrower.id )
    if borrower_records.any? && borrower_records.size == 1   #problematic if there are numerous checkouts for one copy 
      borrower_record = borrower_records.first
      borrower_record.return_date = current_date
      borrower_record.status = "returned"
      @book_copy.status = "available"
      @book_copy.due_date = nil
      @book_copy.library_id = checkout_params[:library_id] if checkout_params[:library_id].present?
      
      @book_copy.save!
      borrower_record.save!

      render json: { book_copy_id: @book_copy.id }, status: :ok
    else
      render json: { message: "Please see a librarian. There is a problem with this borrower record."}, status: :unprocessable_entity
    end
  end

  private 
  def checkout_params
    params.require(:checkout_info).permit(:borrower_id, :library_id)
  end

  def find_book_copy
    @book_copy = BookCopy.find(params[:id].to_i)
  end

  def find_borrower
    if checkout_params[:borrower_id].nil?
      raise ActionController::ParameterMissing
    end
    @borrower = Borrower.find(checkout_params[:borrower_id])
  end

  def record_not_found
    render json: { error: 'There was a problem finding the borrower information or the book'}, status: :unprocessable_entity
  end

  def parameter_missing
    render json: { error: 'The request was missing one or more parameters'}, status: :unprocessable_entity
  end

  def general_error
    render json: { error: 'A problem was encountered.' }, status: :unprocessable_entity
  end
end
