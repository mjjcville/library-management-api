# The Library Api

Welcome to the Library Api.  This Api provides access to the Library System. 

## What is the Library System? 
The Library System is a database which keeps track of:
  - Libraries, by name
  - Books, including author and publishing information
  - Borrowers, including borrowing history and fee information

### A few things to note
In the creation of this Library Api, there were a few design decisions and assumptions that are worth understanding.
  - The api is versioned.  The current version is V1. All endpoints are nested under api/v1. The designer chose this because it is explicit and lends itself to a readable directory structure.
  - The api is using the devise gem and jwt for authentication. Each librarian must sign up once. After that, login, get a token and pass that token with each api call.
  - Most resources are the object of the action:
    - Books are added to libraries and inventory. Books are searched for.
    - Book Copies are checked out and returned.
    - Borrowers are created and registered.
    - Libraries are created
    - Users (librarians) are created and signed in
    - The only exception has to do with Fees.
      - Borrowers ask about and pay fees.  This is slightly different, but becuase a borrower may have fees connected to several late books, it made more sense to make the action come from the Borrower. If it had come from the fee, there would have been added complexity in getting the borrower information (history) and finding other fees associated with that Borrower.
  - Books have only one author. Authors can have many books though. In reality, this is absurd, but in the interest of time the designer opted to implement the many to many relationship between authors and books in a later release. 
  - Book copies are checked out of whatever library they belong to. The borrower must have access to that library. However, a book can be returned to any library in the system, whether the borrower also has a registration there.
  - When a borrower pays their fees, they pay the entirety, not the fee for just one of potentially many books. 
  - Also in the interest of time, the designer opted to move the following to future enhancements:
    - Libraries should have timezones to make the checkout and return information more correct. It is possible to check a book out on the east coast, and return it on the west coast. The timezone of the library would influence the date columns such as due_date, etc..
    - Minor refactoring of the controllers to consolidate the error handling.  Initially, the designer thought each controller would have unique error handling. By the time the api was nearing completion, it became apparent that there were standard operations that could be dried up and moved to application_controller.rb
    - Roles. Currently, the user is created and is authorized for all endpoints. Implementation of the devise gem ended up consuming vast amounts of time, so authentication was achieved but not authorization.  Also there is an incredible weakness in that anyone can create themselves as a user. This is a noted security concern and must be addressed prior to deployment.
    - Pagination and Rate limiting. These absolutely must be handled prior to deployment for get endpoints.

### Setup

1. Clone the repo: ```git@github.com:mjjcville/library-management-api.git```
2. Go to the directory library-management-api
3. Make sure you have ruby (3.2.2) installed.
4. Make sure you have rails (7.1.2) installed.
5. Create a development secret key (replace 'code --wait' with editor of choice):  ```EDITOR="code --wait" rails credentials:edit --environment=development```
6. ```rails db:prepare```
7. ```rails db:test:prepare```
8. ```rails s```

### How to use:
Once the server is running, you can use Postman or curl easily. 
1. Create an authenticated user: ```curl --location 'localhost:3000/signup' \
--form 'user[email]="test@test.com"' \
--form 'user[password]="password"'```
2. Using the same email and password, find your token by running the following curl and then looking for the authorization header. Save the token that comes after 'Bearer':```curl -i --location 'localhost:3000/login' \
--form 'user[email]="test@test.com"' \
--form 'user[password]="password"'```

Now you are officially a librarian with a secure token. You have all the power.

The database has been seeded with a few libraries, their collections, books with publishing info, a borrower or two etc...

#### Library endpoint
A great place to start though is by creating a new library:
  - Endpoint:  /api/v1/libraries
  - Action: POST
  - Params: {
        library: {
          name: "name",
          description: "description"
        }}
  - Example: ```curl --location 'localhost:3000/api/v1/libraries' \
--header 'Authorization: Bearer put-your-token-here' \
--form 'library[name]="Your Library"'```

#### Books endpoint
##### Show all the books - either across the system (use global flag) or for a particular library
  - Endpoint: /api/v1/books
  - Action: GET
  - Params: {
      book: {
        global_search: true,
        title: "and"
      }
    }
  - Notes:  The presence of the global_search flag will result in all copies at all libraries, the absence of the flag in addition to a specific library_id will show copies in one collection.
  - Example: ```curl --location --request GET 'localhost:3000/api/v1/books' \
--header 'Authorization: Bearer {token}' \
--form 'book[global_search]="true"' \
--form 'book[title]="and"'```

##### Add a new book and put it in a collection
  - Endpoint: /api/v1/books
  - Action: GET
  - Params: {
      book: {
        library_id: 1,
        title: "Test Title",
        isbn: "0000011111",
        author_first_name: "John",
        author_last_name: "Test"
      }
    }
  - Notes:  The presence of the global_search flag will result in all copies at all libraries, the absence of the flag in addition to a specific library_id will show copies in one collection.
  - Example: ```curl --location 'localhost:3000/api/v1/books' \
--header 'Authorization: Bearer {token}' \
--form 'book[title]="Rocks and Hills"' \
--form 'book[isbn]="999999"' \
--form 'book[library_id]="10"' \
--form 'book[author_first_name]="John"' \
--form 'book[author_last_name]="Writer"'```



## Book Copies endpoint
##### Checkout a book
  - Endpoint: /api/v1/book_copies/:id/checkout
  - Action: POST
  - Params: {
      checkout_info: {
        borrower_id: 1,
        library_id: 1
      }
    }
  - Notes: A couple of checks here. The borrower must have registered at the library where the book copy is part of the collection
  - EXAMPLE: ``````

##### Checkout a book
  - Endpoint: /api/v1/book_copies/:id/checkin
  - Action: POST

## Borrowers endpoint
##### Add a new borrower
  - Endpoint: /api/v1/borrowers
  - Action: POST
  - Params: {
      borrower: {
        library_id: 1,
        first_name: "Test Title",
        last_name: "0000011111",
        credit_card_number: "John",
        credit_card_expiration: "Test",
        credit_card_security_code: "111"
      }
    }
  - Notes: If the library_user record does not exist it will be created.  If it does it will be connected to the library.
  - Example: ```curl --location 'localhost:3000/api/v1/borrowers' \
--header 'Authorization: Bearer token' \
--form 'borrower[first_name]="Jane"' \
--form 'borrower[last_name]="Reader"' \
--form 'borrower[credit_card_number]="10"' \
--form 'borrower[credit_card_expiration]="11"' \
--form 'borrower[credit_card_security_code]="12"' \
--form 'borrower[library_id]="10"'```

##### See a borrower's fees

- Endpoint: /api/v1/borrowers/{borrower_id}/fee_total
  - Action: GET
  - Params: {}
  - Example: ```curl --location 'localhost:3000/api/v1/borrowers/3/fee_total' \
--header 'Authorization: Bearer {token}'```


##### Pay a borrower's fees, in full

- Endpoint: /api/v1/borrowers/{borrower_id}/pay
  - Action: POST
  - Params: {}
  - Example: ```curl --location 'localhost:3000/api/v1/borrowers/3/pay' \
--header 'Authorization: Bearer {token}'```


