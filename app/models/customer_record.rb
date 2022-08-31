class CustomerRecord < ApplicationRecord
  belongs_to :customer_list

  validates :first_name, :last_name, :vehicle_type, presence: true
  validates :vehicle_length, numericality: { greater_than_or_equal_to: 0 }

  scope :all_in_list, ->(customer_list_id) {
    ActiveRecord::Base.connection.execute(
      <<-SQL
        SELECT
          (last_name || ', ' || first_name) as full_name,
          email,
          vehicle_type,
          vehicle_name,
          vehicle_length
        FROM
          customer_records
        WHERE
          customer_list_id = #{ActiveRecord::Base.connection.quote(customer_list_id)}
      SQL
    )
  }

  def full_name
    "#{last_name}, #{first_name}"
  end
end
