# One file to contain all the factories for testing

#Library
FactoryBot.define do
factory :library do
name { "Test Library" }
end
end

#Author
FactoryBot.define do
factory :author do
first_name { "Jane" }
last_name  { "Doe" }
end
end

#Book
FactoryBot.define do
factory :book do
isbn { "isbntest123"}
title { "A good book" }
association :author
end
end

#BookCopy
FactoryBot.define do
factory :book_copy do
association :book
association :library
end
end

#checkout activities
# FactoryBot.define do
# factory :checkout_activity do
# status { "Test Library" }
# last_name  { "Doe" }
# admin { false }
# end
# end

# Patron
FactoryBot.define do
factory :user do
first_name { "Test" }
last_name { "User"}
credit_card_number {"1111-2222-3333-4444"}
credit_card_expiration {"01/28"}
credit_card_security_code {"999"}
end
end

#Patron Registration
FactoryBot.define do
factory :borrower do
join_date { DateTime.now - 1.month}
association :user
association :library
end
end