class CreateFees < ActiveRecord::Migration[7.1]
  def up
    create_table :fees, if_not_exists: true  do |t|
      t.decimal :fee_amount, precision: 5, scale: 2
      t.integer :status
      t.references :borrower_record, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :fees, if_exists: true
  end
end
