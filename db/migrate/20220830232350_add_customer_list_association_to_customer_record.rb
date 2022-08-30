class AddCustomerListAssociationToCustomerRecord < ActiveRecord::Migration[7.0]
  def change
    change_table :customer_records do |t|
      t.belongs_to :customer_list, index: true, foreign_key: true
    end
  end
end
