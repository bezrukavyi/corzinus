module Corzinus
  describe Checkout::StepDelivery do
    let(:order) { create :corzinus_order, :with_products }
    let(:delivery) { create :corzinus_delivery }
    let(:params) { { delivery_id: delivery.id } }

    describe '#call' do
      subject { Checkout::StepDelivery.new(order: order, params: params) }

      context 'valid' do
        it ':valid broadcast' do
          expect { subject.call }.to broadcast(:valid)
        end
        it 'update order' do
          expect { subject.call }.to change(order, :delivery).from(nil)
        end
      end

      it ':invalid broadcast' do
        allow(subject).to receive(:delivery_id).and_return(nil)
        expect { subject.call }.to broadcast(:invalid)
      end
    end
  end
end
