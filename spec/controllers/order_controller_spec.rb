RSpec.describe 'OrdersController', type: :request do
  describe 'POST create' do
    context 'order is valid' do
      it 'order is created' do
        expect(VendorXyzWrapper).to receive(:create_order) { VendorXyzWrapper::Order.new(id: 1, status: 'pending') }

        post '/orders', params: {
          customer_id: '5c7a77843b72c706a37e9478',
          order_lines: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
        }

        expect(response).to have_http_status(201)
      end
    end

    context 'order is invalid' do
      it 'order is not created' do
        expect(VendorXyzWrapper).to receive(:create_order) { VendorXyzWrapper::Order.new(status: 'declined') }

        post '/orders', params: {
          customer_id: '5c7a77843b72c706a37e9478',
          order_lines: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
        }

        expect(response).to have_http_status(422)
      end
    end
  end
end
