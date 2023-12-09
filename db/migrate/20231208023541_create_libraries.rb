class CreateLibraries < ActiveRecord::Migration[7.1]
  def up
    create_table :libraries, if_not_exists: true do |t|
      t.string :name, null: false
      t.text :description

      t.string :address_line1
      t.string :address_line2
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end

  def down
    drop_table :libraries, if_exists: true
  end

end
