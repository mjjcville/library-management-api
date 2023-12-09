class CreateAuthors < ActiveRecord::Migration[7.1]
  def up
    create_table :authors, if_not_exists: true do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
  end

  def down
    drop_table :authors, if_exists: true
  end

end
