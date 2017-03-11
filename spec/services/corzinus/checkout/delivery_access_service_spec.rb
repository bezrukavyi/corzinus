module Corzinus
  describe Checkout::DeliveryAccessService, type: :service do
    let(:order) { create :corzinus_order, :full_package }

    describe '#valid?' do
      it 'when true' do
        subject = Checkout::DeliveryAccessService.new(order)
        expect(subject.valid?).to be_truthy
      end

      it 'when false' do
        subject = Checkout::DeliveryAccessService.new(order)
        order.update(delivery: nil)
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
