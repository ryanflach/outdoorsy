FactoryBot.define do
  factory :customer_list do
    list { nil }
    filename { "my_customers.txt" }
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
