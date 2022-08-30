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
    first_name { "Jack" }
    last_name { "Aubrey" }
    email { "themasterandthecommander@sail.me" }
    vehicle_name { "Sophie" }
    vehicle_type  { "sailboat" }
    vehicle_length { 78 }
  end
end
