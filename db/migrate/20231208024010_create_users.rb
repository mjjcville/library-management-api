class CreateUsers < ActiveRecord::Migration[7.1]
  def up
    create_table :users, if_not_exists: true do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :credit_card_number, null: false 
      t.string :credit_card_expiration, null: false
      t.string :credit_card_security_code, null: false

      t.timestamps
      t.index [:first_name, :last_name, :credit_card_number, :credit_card_expiration, :credit_card_security_code], unique: true
    end
  end

  def down
    drop_table :users, if_exists: true
  end

end
