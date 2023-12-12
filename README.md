# The Library Api

Welcome to the Library Api.  This Api provides access to the Library System. 

## What is the Library System? 
The Library System is a database which keeps track of:
  - Libraries, by name
  - Books, including author and publishing information
  - Borrowers, including borrowing history and fee information

### A few things to note
In the creation of this Library Api, there were a few design decisions and assumptions that are worth understanding.
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

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
