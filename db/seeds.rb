# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
# MovieGenre.find_or_create_by!(name: genre_name)
#   end

current_date = DateTime.now
yesterday = current_date - 1.day
next_week = current_date + 1.week

#Basic Library set up
north_library = Library.find_or_create_by!(name: "North Library", description: "Library on the north side of town")
east_library = Library.find_or_create_by!(name: "East Library", description: "Library on the east side of town")
south_library = Library.find_or_create_by!(name: "South Library", description: "Library on the south side of town")
west_library = Library.find_or_create_by!(name: "West Library", description: "Library on the west side of town")

#Basic Authors
author_austen = Author.find_or_create_by!(first_name: "Jane", last_name: "Austen")
author_shakespeare = Author.find_or_create_by!(first_name: "William", last_name: "Shakespeare")
author_tolkien = Author.find_or_create_by!(first_name: "J.R.R.", last_name: "Tolkien")
author_grisham = Author.find_or_create_by!(first_name: "John", last_name: "Grisham")

#Books belonging to authors
book_1 = Book.find_or_create_by!(isbn:"0100000000", title: "Pride and Predjudice", author_id: author_austen.id)
book_2 = Book.find_or_create_by!(isbn:"0200000000", title: "Sense and Sensibility", author_id: author_austen.id)
book_3 = Book.find_or_create_by!(isbn:"0300000000", title: "Persuasion", author_id: author_austen.id)
book_4 = Book.find_or_create_by!(isbn:"0400000000", title: "Henry VI, Part I", author_id: author_shakespeare.id)
book_5 = Book.find_or_create_by!(isbn:"0500000000", title: "Henry VI, Part II", author_id: author_shakespeare.id)
book_6 = Book.find_or_create_by!(isbn:"0600000000", title: "Henry VI, Part III", author_id: author_shakespeare.id)
book_7 = Book.find_or_create_by!(isbn:"0700000000", title: "The Hobbit", author_id: author_tolkien.id)
book_8 = Book.find_or_create_by!(isbn:"0800000000", title: "The Hobbit, audiobook", author_id: author_tolkien.id)
book_9 = Book.find_or_create_by!(isbn:"0900000000", title: "As you like it", author_id: author_shakespeare.id)

#Initial copy of books, in specific collections
BookCopy.find_or_create_by!(status: "available", book_id: book_1.id, library_id: north_library.id )
BookCopy.find_or_create_by!(status: "available", book_id: book_1.id, library_id: east_library.id )
BookCopy.find_or_create_by!(status: "available", book_id: book_2.id, library_id: north_library.id )
BookCopy.find_or_create_by!(status: "available", book_id: book_2.id, library_id: east_library.id )
BookCopy.find_or_create_by!(status: "available", book_id: book_3.id, library_id: north_library.id )
BookCopy.find_or_create_by!(status: "available", book_id: book_4.id, library_id: west_library.id )
BookCopy.find_or_create_by!(status: "available", book_id: book_5.id, library_id: west_library.id )
BookCopy.find_or_create_by!(status: "available", book_id: book_6.id, library_id: west_library.id )

#Additional copies of books in specific locations
BookCopy.create!(status: "checked_out", due_date: yesterday, book_id: book_1.id, library_id: north_library.id )
BookCopy.create!(status: "checked_out", due_date: next_week, book_id: book_2.id, library_id: north_library.id )