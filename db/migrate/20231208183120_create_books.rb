class CreateBooks < ActiveRecord::Migration[7.1]
  def up
    create_table :books, if_not_exists: true do |t|
      t.string :isbn, null: false
      t.string :title, null: false
      t.datetime :publishing_date
      
      t.references :author, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :books, if_exists: true
  end

end
