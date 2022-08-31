module ListRecordsPresenter
  def self.present(records, requested_order)
    ordered_records(records, requested_order).map do |record|
      {
        full_name: record.full_name,
        email: record.email,
        vehicle_type: record.vehicle_type,
        vehicle_name: record.vehicle_name,
        vehicle_length: record.vehicle_length
      }
    end
  end

  def self.ordered_records(records, requested_order)
    case requested_order
    when "full_name"
      records.by_full_name
    when "vehicle_type"
      records.by_vehicle_type
    else
      records
    end
  end
end
