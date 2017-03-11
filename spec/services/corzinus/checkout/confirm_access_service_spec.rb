module Corzinus
  describe Checkout::ConfirmAccessService, type: :service do
    let(:order) { create :corzinus_order, :full_package }

    describe '#valid?' do
      it 'when true' do
        subject = Checkout::ConfirmAccessService.new(order)
        allow(order).to receive(:in_progress?).and_return(true)
        expect(subject.valid?).to be_truthy
      end

      it 'when false' do
        subject = Checkout::ConfirmAccessService.new(order)
        allow(order).to receive(:in_progress?).and_return(false)
        expect(subject.valid?).to be_falsey
      end
    end
  end
end
