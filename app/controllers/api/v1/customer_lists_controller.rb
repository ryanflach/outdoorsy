class Api::V1::CustomerListsController < ApplicationController
  def create
    customer_list = CustomerList.new(create_params)
    if customer_list.save
      processed_list = customer_list.process_list
      render_results(processed_list)
    else
      render json: { errors: customer_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    list = CustomerList.where(id: params[:id]).first
    if list.present?
      list.destroy
      head :no_content
    else
      render json: { errors: ["CustomerList does not exist"] }, status: :not_found
    end
  end

  private

  def create_params
    params.require(:customer_lists).permit(:list)
  end

  def render_results(processed_list)
    if processed_list.save
      render json: {
        id: processed_list.id,
        filename: processed_list.filename,
        num_records: processed_list.num_records
      }, status: :created
    else
      errors = processed_list.errors.full_messages
      processed_list.destroy
      render json: { errors: errors }, status: :unprocessable_entity
    end
  end
end
