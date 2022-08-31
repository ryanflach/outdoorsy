class Api::V1::ListRecordsController < ApplicationController
  def index
    list = CustomerList.where(id: params[:customer_list_id]).first
    if list.present?
      render json: ListRecordsPresenter.present(list.customer_records, params[:order_by]), status: :ok
    else
      render json: { errors: ["CustomerList does not exist"] }, status: :not_found
    end
  end
end
