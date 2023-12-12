# api/v1/libraries_controller.rb

class Api::V1::LibrariesController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    library = Library.find_by(name: library_params[:name])

    if library.present?
      render json: {message: "The Library was found with ID: #{library.id}"}, status: :ok
    else
      library = Library.new(library_params)
      if library.save
        render json: {message: "The Library was created with ID: #{library.id}"}, status: :created
      else
        render json: {error: 'The library could not be created or found.'}, status: :unprocessable_entity
      end
    end
  end
 
  private
  def library_params
    params.require(:library).permit(:name, :description, :address_line_1, :address_line_2, :city, :state, :zip)
  end

  def parameter_missing
    render json: { error: 'The request was missing one or more parameters'}, status: :unprocessable_entity
  end

  def record_not_found
    render json: { error: 'The Library requested does not exist' }, status: :not_found
  end
end
