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

ActiveRecord::Schema[7.1].define(version: 2023_12_08_194519) do
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

  create_table "checkout_activities", force: :cascade do |t|
    t.datetime "checkout_date", null: false
    t.datetime "return_date"
    t.integer "status", default: 0, null: false
    t.integer "patron_registration_id", null: false
    t.integer "book_copy_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_copy_id"], name: "index_checkout_activities_on_book_copy_id"
    t.index ["patron_registration_id"], name: "index_checkout_activities_on_patron_registration_id"
  end

  create_table "libraries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patron_registrations", force: :cascade do |t|
    t.datetime "join_date", null: false
    t.datetime "cancel_date"
    t.integer "status", default: 0, null: false
    t.integer "library_id", null: false
    t.integer "patron_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["library_id"], name: "index_patron_registrations_on_library_id"
    t.index ["patron_id"], name: "index_patron_registrations_on_patron_id"
  end

  create_table "patrons", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "credit_card_number", null: false
    t.string "credit_card_expiration", null: false
    t.string "credit_card_security_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "book_copies", "books"
  add_foreign_key "book_copies", "libraries"
  add_foreign_key "books", "authors"
  add_foreign_key "checkout_activities", "book_copies"
  add_foreign_key "checkout_activities", "patron_registrations"
  add_foreign_key "patron_registrations", "libraries"
  add_foreign_key "patron_registrations", "patrons"
end
