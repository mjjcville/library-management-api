class CreateBorrowerRecords < ActiveRecord::Migration[7.1]
  def up
    create_table :borrower_records, if_not_exists: true do |t|
      t.datetime :checkout_date, null: false
      t.datetime :return_date
      t.integer :status, null: false, default: 0

      t.references :borrower, null: false, foreign_key: true
      t.references :book_copy, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :borrower_records, if_exists: true
  end
end
