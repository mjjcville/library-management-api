class CreatePatrons < ActiveRecord::Migration[7.1]
  def up
    create_table :patrons, if_not_exists: true do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :credit_card_number, null: false 
      t.string :credit_card_expiration, null: false
      t.string :credit_card_security_code, null: false

      t.timestamps
    end
  end

  def down
    drop_table :patrons, if_exists: true
  end

end
