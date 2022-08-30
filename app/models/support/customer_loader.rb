class CustomerLoader
  def self.process_file!(file_path)
    new(file_path).process!
  end

  def initialize(file_path)
    @file_path = file_path
  end

  def process!
    delete_existing_records
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

  def delete_existing_records
    CustomerRecord.delete_all
  end

  def parse_file_and_create_customer_records
    file = File.readlines(@file_path).lazy
    delimiter = file.first.match(SUPPORTED_DELIMITERS)[0]

    file.each do |row|
      values = row.split(delimiter)
      assigned_values = COLUMN_ORDER.zip(values).to_h.tap do |values|
        values[:vehicle_length] = values[:vehicle_length].match(%r(\d+))[0]
      end
      CustomerRecord.create!(assigned_values)
    end
  end
end
