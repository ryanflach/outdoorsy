class CustomerListProcessor
  def self.process_list(customer_list, list_file_path)
    new(customer_list, list_file_path).process
  end

  def initialize(customer_list, list_file_path)
    @customer_list = customer_list
    @list_file_path = list_file_path
  end

  def process
    parse_file_and_create_customer_records
  end

  private

  SUPPORTED_DELIMITERS = %r([,\|]).freeze
  COLUMN_ORDER = %i[
    first_name
    last_name
    email
    vehicle_type
    vehicle_name
    vehicle_length
  ].freeze

  def parse_file_and_create_customer_records
    file = File.readlines(@list_file_path).lazy
    return if file.first.blank?
    delimiter = file.first.match(SUPPORTED_DELIMITERS)[0]
    build_customer_records(file, delimiter)
  end

  def build_customer_records(file, delimiter)
    file.each do |row|
      values = row.split(delimiter)
      cleaned_values = values.map { |v| v&.strip&.upcase }
      assigned_values = COLUMN_ORDER.zip(cleaned_values).to_h.tap do |values|
        values[:vehicle_length] = get_integer_length_value(values[:vehicle_length])
      end

      @customer_list.customer_records << CustomerRecord.new(assigned_values)
    end
  end

  def get_integer_length_value(raw_value_with_optional_measurement_descriptor)
    raw_value_with_optional_measurement_descriptor.match(%r(\d+))[0]
  end
end
