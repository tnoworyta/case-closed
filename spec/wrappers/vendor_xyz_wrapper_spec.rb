RSpec.describe 'VendorXyzWrapper' do
  describe '#create_order' do
    context 'order is valid' do
      it 'order created' do
        expect_any_instance_of(VendorXyzClient).to receive(:order_total)
          .with(customer_id: '5c7a77843b72c706a37e9478', items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]) {
            {
              data: {
                total: {
                totalAmount: { amountCents: 694000, taxCents: 10234 },
                  customerId: '5c7a77843b72c706a37e9478',
                  items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
                }
              }
            }
          }

        expect_any_instance_of(VendorXyzClient).to receive(:create_order)
          .with(customer_id: '5c7a77843b72c706a37e9478', total_amount: 704234, items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]) {
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
          }

        order = VendorXyzWrapper.create_order(
          customer_id: '5c7a77843b72c706a37e9478',
          order_lines: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
        )

        expect(order).to be_kind_of(VendorXyzWrapper::Order)
        expect(order.status).to eq('pending')
      end
    end

    context 'order is invalid' do
      it 'order not created' do
        expect_any_instance_of(VendorXyzClient).to receive(:order_total)
          .with(customer_id: '5c7a77843b72c706a37e9478', items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]) {
            {
              data: {
                total: {
                totalAmount: { amountCents: 694000, taxCents: 10234 },
                  customerId: '5c7a77843b72c706a37e9478',
                  items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
                }
              }
            }
          }

        expect_any_instance_of(VendorXyzClient).to receive(:create_order)
          .with(customer_id: '5c7a77843b72c706a37e9478', total_amount: 704234, items: [{code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]) {
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
            }
          }

        order = VendorXyzWrapper.create_order(
          customer_id: '5c7a77843b72c706a37e9478',
          order_lines: [ {code: 'abcj493', quantity: 3}, {code: 'ghtj42', quantity: 1}]
        )

        expect(order).to be_kind_of(VendorXyzWrapper::Order)
        expect(order.status).to eq('declined')
      end
    end

  end
end
