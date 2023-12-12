# api/v1/borrowers_controller.rb

class Api::V1::BorrowersController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  
  def create
    current_date = DateTime.now
    
    #Create or find the user record that matches the information in the params
    #First checking for existence, then creating if necessary instead of using the convenient
    #method for doing both.  This way a more explicit and appropriate HTTP status code can be returned:
    #   1. Created User and Borrower ---> 201
    #   2. Found User, created Borrower ---> 201
    #   3. Found User, found Borrower ---> 200

    user = User.find_by(
      first_name: borrower_params[:first_name],
      last_name: borrower_params[:last_name],
      credit_card_number: borrower_params[:credit_card_number],
      credit_card_expiration: borrower_params[:credit_card_expiration],
      credit_card_security_code: borrower_params[:credit_card_security_code]
    )

    if user.nil?
      user = User.create!(
        first_name: borrower_params[:first_name],
        last_name: borrower_params[:last_name],
        credit_card_number: borrower_params[:credit_card_number],
        credit_card_expiration: borrower_params[:credit_card_expiration],
        credit_card_security_code: borrower_params[:credit_card_security_code]
      )
      borrower = Borrower.create!(user_id: user.id, library_id: borrower_params[:library_id], join_date: current_date)
      render json: { borrower_id: borrower.id }, status: :created
    else
      borrower = Borrower.find_by(user_id: user.id, library_id: borrower_params[:library_id])
      if borrower.nil?
        borrower = Borrower.create!(user_id: user.id, library_id: borrower_params[:library_id], join_date: current_date)
        render json: { borrower_id: borrower.id }, status: :created
      else
        render json: { borrower_id: borrower.id }, status: :ok
      end
    end
  end

  private
  def borrower_params
    params.require(:borrower).permit(:library_id, :first_name, :last_name, :credit_card_number, :credit_card_expiration, :credit_card_security_code)
  end

  def record_invalid
    render json: { error: 'There was a problem registering the Borrower.' }, status: :unprocessable_entity
  end

  def parameter_missing
    render json: { error: 'The request was missing one or more parameters'}, status: :unprocessable_entity
  end
end