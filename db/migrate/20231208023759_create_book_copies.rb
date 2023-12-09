class CreateBookCopies < ActiveRecord::Migration[7.1]
  def up
    create_table :book_copies, if_not_exists: true do |t|
      t.datetime :due_date
      t.text :description
      t.integer :status, null: false, default: 0

      t.references :book, null: false, foreign_key: true
      t.references :library, null: false, foreign_key: true

      t.timestamps 
    end
  end

  def down
    drop_table :book_copies, if_exists: true
  end

end
