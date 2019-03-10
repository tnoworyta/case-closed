class OrdersController < ApplicationController
  def create
    order = VendorXyzWrapper.create_order(
      customer_id: params[:customer_id],
      order_lines: params[:order_lines]
    )
    if order.id
      head 201
    else
      head 422
    end
  end
end
