class VendorXyzWrapper
  include Singleton

  def initialize
    @vendor_xyz_client = VendorXyzClient.new
  end

  class << self
    delegate :create_order, to: :instance
  end

  def create_order(customer_id:, order_lines:)
    total_data = vendor_xyz_client.order_total(customer_id: customer_id, items: order_lines)
    totals = total_data.fetch(:data, {}).fetch(:total).fetch(:totalAmount)
    order_data = vendor_xyz_client.create_order(
      customer_id: customer_id,
      total_amount: totals.fetch(:amountCents, 0) + totals.fetch(:taxCents, 0),
      items: order_lines
    )
    order_attributes = order_data.fetch(:data, {}).fetch(:order, {})
    Order.new(id: order_attributes[:orderId], status: order_attributes[:status])
  end

  private

  attr_reader :vendor_xyz_client
end
