class CreateCustomerRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_records do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :vehicle_name
      t.string :vehicle_type, null: false
      t.integer :vehicle_length
      t.timestamps
    end
  end
end
