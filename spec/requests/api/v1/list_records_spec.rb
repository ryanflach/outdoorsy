require 'rails_helper'

RSpec.describe "Api::V1::ListRecords", type: :request do
  describe "GET /index" do
    subject { get "/api/v1/customer_lists/#{list_id}/list_records", params: params }

    context "with a found list" do
      let!(:existing_customer_list) { create(:customer_list) }
      let!(:existing_list_sailer) do
        create(
          :customer_record,
          last_name: "AUBREY",
          vehicle_type: "SAILBOAT",
          customer_list: existing_customer_list
        )
      end
      let!(:existing_list_motorboater) do
        create(
          :customer_record,
          last_name: "DAWSON",
          vehicle_type: "MOTORBOAT",
          customer_list: existing_customer_list
        )
      end
      let(:list_id) { existing_customer_list.id }

      shared_examples "a valid request" do
        before { subject }

        it "returns the expected number of records" do
          expect(JSON.parse(response.body).length)
            .to eq(existing_customer_list.customer_records.count)
        end

        it "returns the records in the expected format in its response body" do
          expect(JSON.parse(response.body)).to include(
            {
              "full_name" => existing_list_sailer.full_name,
              "email" => existing_list_sailer.email,
              "vehicle_type" => existing_list_sailer.vehicle_type,
              "vehicle_name" => existing_list_sailer.vehicle_name,
              "vehicle_length" => existing_list_sailer.vehicle_length,
            }
          )
        end

        it "returns an OK status" do
          expect(response).to have_http_status(:ok)
        end
      end

      context "without ordering" do
        let(:params) { {} }

        it_behaves_like "a valid request"
      end

      context "with valid ordering of full_name" do
        let(:params) { { order_by: "full_name" } }

        it_behaves_like "a valid request"

        it "orders returned records by full_name (<last_name>, <first_name>)" do
          subject
          expect(JSON.parse(response.body).first["full_name"])
            .to eq(existing_list_sailer.full_name)
        end
      end

      context "with valid ordering of vehicle_type" do
        let(:params) { { order_by: "vehicle_type" } }

        it_behaves_like "a valid request"

        it "orders returned records by vehicle_type" do
          subject
          expect(JSON.parse(response.body).first["vehicle_type"])
            .to eq(existing_list_motorboater.vehicle_type)
        end
      end

      context "with invalid ordering" do
        let(:params) { { order_by: "nonexistent column" } }

        it_behaves_like "a valid request"
      end
    end

    context "without a found list" do
      before { subject }
      let(:list_id) { 9999 }
      let(:params) { {} }

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
