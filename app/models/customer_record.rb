class CustomerRecord < ApplicationRecord
  belongs_to :customer_list

  validates :first_name, :last_name, :vehicle_type, presence: true
  validates :vehicle_length, numericality: { greater_than_or_equal_to: 0 }

  scope :by_full_name, -> { order(:last_name) }
  scope :by_vehicle_type, -> { order(:vehicle_type) }

  def full_name
    "#{last_name}, #{first_name}"
  end
end
