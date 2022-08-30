require 'rails_helper'

RSpec.describe CustomerLoader do
  describe ".process_file!" do
    shared_examples "a file with a valid delimiter" do |filename|
      before(:all) do
        create(:customer_record)
        CustomerLoader.process_file!(filename)
      end

      let(:num_records_in_test_file) { 4 }
      let(:expected_sample_record) do
        {
          first_name: "Ansel",
          last_name: "Adams",
          email: "a@adams.com",
          vehicle_type: "motorboat",
          vehicle_name: "Rushing Water",
          vehicle_length: 24
        }
      end

      it "should remove existing records" do
        expect(CustomerRecord.count).to eq(num_records_in_test_file)
      end

      it "should parse the file and store the correct values in the records" do
        sample_record = CustomerRecord.find_by(email: expected_sample_record[:email])

        expect(sample_record.first_name).to eq(expected_sample_record[:first_name])
        expect(sample_record.last_name).to eq(expected_sample_record[:last_name])
        expect(sample_record.email).to eq(expected_sample_record[:email])
        expect(sample_record.vehicle_type).to eq(expected_sample_record[:vehicle_type])
        expect(sample_record.vehicle_name).to eq(expected_sample_record[:vehicle_name])
        expect(sample_record.vehicle_length).to eq(expected_sample_record[:vehicle_length])
      end
    end

    context "with a comma delimiter" do
      it_behaves_like "a file with a valid delimiter", Rails.root.join("spec", "test_data", "commas.txt")
    end

    context "with a pipe delimiter" do
      it_behaves_like "a file with a valid delimiter", Rails.root.join("spec", "test_data", "pipes.txt")
    end
  end
end
