class CreateBorrowers < ActiveRecord::Migration[7.1]
  def up
    create_table :borrowers, if_not_exists: true do |t|
      t.datetime :join_date, null: false
      t.datetime :cancel_date
      t.integer :status, null: false, default: 0

      t.references :library, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.index [:library_id, :user_id], unique: true
      
      t.timestamps
    end
  end

  def down
    drop_table :borrowers, if_exists: true
  end

end
