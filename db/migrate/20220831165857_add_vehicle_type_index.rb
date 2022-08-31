class AddVehicleTypeIndex < ActiveRecord::Migration[7.0]
  def change
    change_table :customer_records do |t|
      t.index :vehicle_type
    end
  end
end
