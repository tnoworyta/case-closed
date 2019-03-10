class VendorXyzClient
  HOST_URL = 'www.example.com'

  def order_total(customer_id:, items:)
    response = HTTParty.post(
      URI::HTTP.build(host: HOST_URL, path: '/orders/total', query: {token: 'tokenabcd'}.to_query),
    {
      body: {
        data: {
          total: {
            customerId: customer_id,
            items: items
          }
        }
      }.to_json
    })
    JSON.parse(response).deep_symbolize_keys
  end

  def create_order(customer_id:, total_amount:, items:)
    response = HTTParty.post(
      URI::HTTP.build(host: HOST_URL, path: '/orders', query: {token: 'tokenabcd'}.to_query),
    {
      body: {
        data: {
          order: {
            totalAmount: total_amount,
            customerId: customer_id,
            items: items
          }
        }
      }.to_json
    })
    JSON.parse(response).deep_symbolize_keys
  end
end
