module Corzinus
  describe Checkout::AddressAccessService, type: :service do
    let(:order) { create :corzinus_order, :full_package }

    describe '#valid?' do
      it 'when true' do
        subject = Checkout::AddressAccessService.new(order)
        expect(subject.valid?).to be_truthy
      end

      it 'when false' do
        subject = Checkout::AddressAccessService.new(order)
        order.update(billing: nil)
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
