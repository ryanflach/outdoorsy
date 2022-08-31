class Api::V1::ListRecordsController < ApplicationController
  def index
    render json: CustomerRecord.all_in_list(params[:customer_list_id]), status: :ok
  end
end
