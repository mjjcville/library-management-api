class Api::V1::BooksController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::ActiveRecordError, with: :general_error

  def index
    formatted_booklist = []
    if book_params[:global_search].present?
      possible_books = Book.where("title LIKE '%#{book_params[:title]}%'").includes(:book_copy)
      possible_books.each do | book |
        formatted_booklist << book.book_copy.map { | copy | { title: book.title, library: copy.library.name }}
      end
    else
      possible_books = Book.where("title LIKE '%#{book_params[:title]}%'").joins(:book_copy).where("book_copies.library_id = ?", book_params[:library_id])
      possible_books.each do | book |
        #If there are multiple copies, this only needs to return one
        #This sorts by due date. Available copies will have a nil due_date and come first.
        #Otherwise the earliest due copy will be first
        copy = book.book_copy.by_due_date.first  
        copy_status = copy.available? ? "Available" : "Due #{copy.due_date}"
        formatted_booklist << { title: book.title, status: copy_status }
      end
    end
    response = { booklist: formatted_booklist.flatten }
    render json: response.to_json, status: :ok
  end

  def create
    #Because there can be multiple copies of a book at a library, using the method create for copies. For Books, there should only 
    #be one record per isbn so using find_or_create. 
    #Either way a book will be added to a library collection, thus creating a record. Successful operations will result in a 201.
    author = Author.find_or_create_by!(first_name: book_params[:author_first_name], last_name: [:author_last_name])

    book = Book.find_or_create_by!(isbn: book_params[:isbn], title: book_params[:title], author_id: author.id)

    book_copy = BookCopy.create!(library_id: book_params[:library_id], book_id: book.id)

    render json: { book_copy_id: book_copy.id }, status: :created
  end

  private 
  def book_params
    params.require(:book).permit(:global_search, :library_id, :isbn, :title, :author_first_name, :author_last_name, :publication_date)
  end

  def parameter_missing
    render json: { error: 'The request was missing one or more parameters'}, status: :unprocessable_entity
  end

  def general_error
    render json: { error: 'A problem was encountered.' }, status: :unprocessable_entity
  end
end
