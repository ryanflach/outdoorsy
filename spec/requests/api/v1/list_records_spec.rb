require 'rails_helper'

RSpec.describe "Api::V1::ListRecords", type: :request do
  describe "GET /index" do
    subject { get "/api/v1/customer_lists/#{list_id}/list_records" }

    context "without ordering" do
      context "with a found list" do
        let!(:existing_customer_list) { create(:customer_list) }
        let!(:existing_list_customer_record) do
          create(:customer_record, customer_list: existing_customer_list)
        end
        let(:list_id) { existing_customer_list.id }

        before { subject }

        it "returns the expected records in its response body" do
          expect(JSON.parse(response.body)).to eq(
            [
              {
                "email" => existing_list_customer_record.email,
                "full_name" => existing_list_customer_record.full_name,
                "vehicle_length" => existing_list_customer_record.vehicle_length,
                "vehicle_name" => existing_list_customer_record.vehicle_name,
                "vehicle_type" => existing_list_customer_record.vehicle_type
              }
            ]
          )
        end

        it "returns an OK status" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "without a found list" do
        let(:list_id) { 666 }
        before { subject }

        it "returns an empty response body" do
          expect(JSON.parse(response.body)).to be_empty
        end

        it "returns an OK status" do
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
