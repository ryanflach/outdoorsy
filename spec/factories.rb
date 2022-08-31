FactoryBot.define do
  factory :customer_list do
    filename { nil }
    after(:build) do |customer_list|
      customer_list.list.attach(
        io: File.open(Rails.root.join("spec", "test_data", "commas.txt")),
        filename: "commas.txt"
      )
    end
  end

  factory :customer_record do
    first_name { "JACK" }
    last_name { "AUBREY" }
    email { "THEMASTERANDTHECOMMANDER@SAIL.ME" }
    vehicle_name { "SOPHIE" }
    vehicle_type  { "SAILBOAT" }
    vehicle_length { 78 }
    customer_list
  end
end
