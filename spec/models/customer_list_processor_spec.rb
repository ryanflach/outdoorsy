require 'rails_helper'

RSpec.describe CustomerListProcessor do
  describe ".process_file" do
    shared_examples "a file with a valid delimiter" do |file_path|
      let(:customer_list) do
        CustomerList.new.tap do |customer_list|
          customer_list.list.attach(io: File.open(file_path), filename: "sample.txt")
          customer_list.save
        end
      end
      let(:num_records_in_test_file) { 4 }
      let(:expected_sample_record) do
        {
          first_name: "ANSEL",
          last_name: "ADAMS",
          email: "A@ADAMS.COM",
          vehicle_type: "MOTORBOAT",
          vehicle_name: "RUSHING WATER",
          vehicle_length: 24
        }
      end

      it "should parse the file and store the formatted values in the records" do
        CustomerListProcessor.process_list(customer_list, customer_list.send(:list_file_path))

        sample_record = customer_list.customer_records.find_by(email: expected_sample_record[:email])

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
