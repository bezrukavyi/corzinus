module Corzinus
  describe Checkout::PaymentAccessService, type: :service do
    let(:order) { create :corzinus_order, :full_package }

    describe '#valid?' do
      it 'when true' do
        subject = Checkout::PaymentAccessService.new(order)
        expect(subject.valid?).to be_truthy
      end

      it 'when false' do
        subject = Checkout::PaymentAccessService.new(order)
        order.update(credit_card: nil)
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
