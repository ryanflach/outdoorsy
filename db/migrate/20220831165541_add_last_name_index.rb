class AddLastNameIndex < ActiveRecord::Migration[7.0]
  def change
    change_table :customer_records do |t|
      t.index :last_name
    end
  end
end
