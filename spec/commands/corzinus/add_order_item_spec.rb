module Corzinus
  describe AddOrderItem do
    let(:order) { create :corzinus_order, :with_products }
    let(:item) { order.order_items.first }
    let(:productable) { item.productable }
    let(:params) { { productable: productable, quantity: 20 } }

    context '#call' do
      subject { AddOrderItem.new(order, params) }
      context 'valid' do
        it 'set valid broadcast' do
          expect { subject.call }.to broadcast(:valid)
        end
        it 'set processing state' do
          expect { subject.call }.to change { item.reload.quantity }
        end
      end

      it 'invalid' do
        invalid_params = { productable: productable, quantity: 1000 }
        subject = AddOrderItem.new(order, invalid_params)
        expect { subject.call }.to broadcast(:invalid)
      end
    end
  end
end
