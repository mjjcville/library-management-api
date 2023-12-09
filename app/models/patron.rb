class Patron < ApplicationRecord
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :credit_card_number, presence: true
    validates :credit_card_expiration, presence: true
    validates :credit_card_security_code, presence: true
end
