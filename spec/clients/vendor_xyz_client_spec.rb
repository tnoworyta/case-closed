require 'spec_helper'

RSpec.describe 'VendorXyzClient' do
  describe '#order_total' do
    context 'valid items' do
      it 'order total returned' do
        allow(ENV).to receive(:fetch).with('API_TOKEN') { 'tokenabcd' }

        order_params = {
          data: {
            total: {
              customerId: '5c7a77843b72c706a37e9478',
              items: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
            }
          }
        }

        stub_request(:post, 'www.example.com/orders/total?token=tokenabcd')
          .with(body: order_params.to_json)
          .to_return(body: {
            data: {
              total: {
              totalAmount: { amountCents: 694000, taxCents: 10234 },
                customerId: '5c7a77843b72c706a37e9478',
                items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
              }
            }
          }.to_json, status: 200)

        expect(VendorXyzClient.new.order_total(customer_id: '5c7a77843b72c706a37e9478', items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}])).to eq({
          data: {
            total: {
            totalAmount: { amountCents: 694000, taxCents: 10234 },
              customerId: '5c7a77843b72c706a37e9478',
              items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
            }
          }
        })
      end
    end

    context 'invalid items' do
      it 'no order total returned' do
        allow(ENV).to receive(:fetch).with('API_TOKEN') { 'tokenabcd' }

        order_params = {
          data: {
            total: {
              customerId: '5c7a77843b72c706a37e9478',
              items: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
            }
          }
        }

        stub_request(:post, 'www.example.com/orders/total?token=tokenabcd')
          .with(body: order_params.to_json)
          .to_return(body: {
            data: {
              errors: [{code: 'abcj493', description: 'out of stock'}]
          }}.to_json, status: 422)

        expect(VendorXyzClient.new.order_total(customer_id: '5c7a77843b72c706a37e9478', items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}])).to eq({
          data: {
            errors: [{code: 'abcj493', description: 'out of stock'}]
          }
        })
      end
    end
  end

  describe '#create_order' do
    context 'order data is valid' do
      it 'order created' do
        allow(ENV).to receive(:fetch).with('API_TOKEN') { 'tokenabcd' }

        order_params = {
          data: {
            order: {
              totalAmount: 704234,
              customerId: '5c7a77843b72c706a37e9478',
              items: [{code: 'abcj493', quantity: 3},  {code: 'ghtj42', quantity: 1}]
            }
          }
        }

        stub_request(:post, 'www.example.com/orders?token=tokenabcd')
          .with(body: order_params.to_json)
          .to_return(body:
          {
            data: {
              order: {
                orderId: 394873,
                status: 'pending',
                totalAmount: 704234,
                customerId: '5c7a77843b72c706a37e9478',
                items: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
              }
            }
          }.to_json, status: 200)

        expect(VendorXyzClient.new.create_order(customer_id: '5c7a77843b72c706a37e9478', total_amount: 704234, items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}])).to eq(
          {
            data: {
              order: {
                orderId: 394873,
                status: 'pending',
                totalAmount: 704234,
                customerId: '5c7a77843b72c706a37e9478',
                items: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
              }
            }
          }
        )
      end
    end

    context 'order data is invalid' do
      it 'order not created' do
        allow(ENV).to receive(:fetch).with('API_TOKEN') { 'tokenabcd' }

        order_params = {
          data: {
            order: {
              totalAmount: 704234,
              customerId: '5c7a77843b72c706a37e9478',
              items: [{code: 'abcj493', quantity: 3},  {code: 'ghtj42', quantity: 1}]
            }
          }
        }

        stub_request(:post, 'www.example.com/orders?token=tokenabcd')
          .with(body: order_params.to_json)
          .to_return(body:
          {
          data: {
            order: {
              errors: [{code: 'abcj493', description: 'out of stock'}],
              status: 'declined',
              totalAmount: 704234,
              customerId: '5c7a77843b72c706a37e9478',
              items: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
            }
          }
        }.to_json, status: 200)

        expect(VendorXyzClient.new.create_order(customer_id: '5c7a77843b72c706a37e9478', total_amount: 704234, items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}])).to eq({
          data: {
            order: {
              errors: [{code: 'abcj493', description: 'out of stock'}],
              status: 'declined',
              totalAmount: 704234,
              customerId: '5c7a77843b72c706a37e9478',
              items: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
            }
          }
        })
      end
    end
  end
end
