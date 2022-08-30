class CreateCustomerLists < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_lists do |t|
      t.string :filename
      t.timestamps

      t.index :filename, unique: true
    end
  end
end
