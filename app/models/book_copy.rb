class BookCopy < ApplicationRecord
    belongs_to :library
    belongs_to :book

    enum :status, [
        :available,
        :checked_out
    ], validate: true

end