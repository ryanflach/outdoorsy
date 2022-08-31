require 'rails_helper'

RSpec.describe "Api::V1::CustomerLists", type: :request do
  describe "POST /create" do
    subject { post "/api/v1/customer_lists", params: params }
    let(:params) { { customer_lists: { list: fixture_file_upload(fixture_path) } } }

    shared_examples "a processable list" do
      before { subject }

      it "responds with an informative body" do
        expect(JSON.parse(response.body)).to eq(
          {
            "id" => CustomerList.first.id,
            "filename" => CustomerList.first.filename,
            "num_records" => CustomerList.first.num_records
          }
        )
      end

      it "returns a created status" do
        expect(response).to have_http_status(:created)
      end
    end

    shared_examples "an unprocessable list" do |expected_errors|
      it "does not create a CustomerList" do
        expect { subject }.to_not change { CustomerList.count }
      end

      it "responds with errors in the body" do
        subject
        expect(JSON.parse(response.body)).to eq("errors" => expected_errors)
      end

      it "responds with an unprocessable_entity status" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with a valid list" do
      context "and valid records" do
        let(:fixture_path) { Rails.root.join("spec", "test_data", "commas.txt") }

        it "creates the list and associated records" do
          expect { subject }
            .to change { CustomerList.count }.from(0).to(1)
            .and change { CustomerRecord.count }.from(0).to(4)
        end

        it_behaves_like "a processable list"
      end

      context "and invalid records" do
        let(:fixture_path) { Rails.root.join("spec", "test_data", "invalid_records.txt") }

        it_behaves_like "an unprocessable list", ["Customer records is invalid"]
      end
    end

    context "with an invalid list" do
      let(:fixture_path) { Rails.root.join("spec", "test_data", "invalid.csv") }

      it_behaves_like "an unprocessable list", ["List must be of file type txt"]
    end

    context "with an empty list" do
      let(:fixture_path) { Rails.root.join("spec", "test_data", "no_records.txt") }

      it "creates the list without any records" do
        expect { subject }.to change { CustomerList.count }.from(0).to(1)
        expect(CustomerList.first.customer_records).to be_empty
      end

      it_behaves_like "a processable list"
    end
  end

  describe "DELETE /destroy" do
    subject { delete "/api/v1/customer_lists/#{list_id}" }

    context "with a found list" do
      let!(:existing_customer_list) { create(:customer_list) }
      let!(:existing_list_customer_record) do
        create(:customer_record, customer_list: existing_customer_list)
      end
      let(:list_id) { existing_customer_list.id }

      it "destroys the list and associated customer records with a no_content status" do
        expect { subject }
          .to change { CustomerList.count }.from(1).to(0)
          .and change { CustomerRecord.count }.from(1).to(0)
      end

      it "returns a no_content status" do
        subject
        expect(response).to have_http_status(:no_content)
      end
    end

    context "without a found list" do
      let(:list_id) { 9999 }
      before { subject }

      it "returns an error in the response body" do
        expect(JSON.parse(response.body)).to eq(
          {
            "errors" => ["CustomerList does not exist"]
          }
        )
      end

      it "returns a not_found status" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
