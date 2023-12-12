# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_12_122519) do
  create_table "authors", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_copies", force: :cascade do |t|
    t.datetime "due_date"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.integer "book_id", null: false
    t.integer "library_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_copies_on_book_id"
    t.index ["library_id"], name: "index_book_copies_on_library_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "isbn", null: false
    t.string "title", null: false
    t.datetime "publishing_date"
    t.integer "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
  end

  create_table "borrower_records", force: :cascade do |t|
    t.datetime "checkout_date", null: false
    t.datetime "return_date"
    t.integer "status", default: 0, null: false
    t.integer "borrower_id", null: false
    t.integer "book_copy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_copy_id"], name: "index_borrower_records_on_book_copy_id"
    t.index ["borrower_id"], name: "index_borrower_records_on_borrower_id"
  end

  create_table "borrowers", force: :cascade do |t|
    t.datetime "join_date", null: false
    t.datetime "cancel_date"
    t.integer "status", default: 0, null: false
    t.integer "library_id", null: false
    t.integer "library_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["library_id", "library_user_id"], name: "index_borrowers_on_library_id_and_library_user_id", unique: true
    t.index ["library_id"], name: "index_borrowers_on_library_id"
    t.index ["library_user_id"], name: "index_borrowers_on_library_user_id"
  end

  create_table "fee_tables", force: :cascade do |t|
    t.decimal "fee_amount"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fees", force: :cascade do |t|
    t.decimal "fee_amount", precision: 5, scale: 2
    t.integer "status"
    t.integer "borrower_record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["borrower_record_id"], name: "index_fees_on_borrower_record_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "library_users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "credit_card_number", null: false
    t.string "credit_card_expiration", null: false
    t.string "credit_card_security_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_name", "last_name", "credit_card_number", "credit_card_expiration", "credit_card_security_code"], name: "idx_on_first_name_last_name_credit_card_number_cred_bb6118ac4b", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.index ["jti"], name: "index_users_on_jti", unique: true
  end

  add_foreign_key "book_copies", "books"
  add_foreign_key "book_copies", "libraries"
  add_foreign_key "books", "authors"
  add_foreign_key "borrower_records", "book_copies"
  add_foreign_key "borrower_records", "borrowers"
  add_foreign_key "borrowers", "libraries"
  add_foreign_key "borrowers", "library_users"
  add_foreign_key "fees", "borrower_records"
end
