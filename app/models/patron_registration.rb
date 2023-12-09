class PatronRegistration < ApplicationRecord
    belongs_to :library
    belongs_to :patron

    validates :join_date, presence: true

    enum :status, [
        :active,
        :quit
    ], validate: true
end
