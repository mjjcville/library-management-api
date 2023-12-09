class Book < ApplicationRecord
    belongs_to :author
    
    validates :isbn, presence: true
    validates :title, presence: true
end
