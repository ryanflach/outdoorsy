class CustomerRecord < ApplicationRecord
  validates :first_name, :last_name, :vehicle_type, presence: true
  validates :vehicle_length, numericality: { greater_than_or_equal_to: 0 }
end
