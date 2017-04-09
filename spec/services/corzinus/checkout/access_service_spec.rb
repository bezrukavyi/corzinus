module Corzinus
  describe Checkout::AccessService, type: :service do
    let(:order) { create :corzinus_order }

    describe '#step_dependencies' do
      before do
        allow(Corzinus).to receive(:checkout_steps)
          .and_return([:address, :payment, :delivery])
      end
      it 'when last step' do
        subject = Checkout::AccessService.new(order)
        allow(subject).to receive(:current_step).and_return(:delivery)
        expect(subject.step_dependencies).to eq([:address, :payment])
      end

      it 'when middle step' do
        subject = Checkout::AccessService.new(order)
        allow(subject).to receive(:current_step).and_return(:payment)
        expect(subject.step_dependencies).to eq([:address])
      end

      it 'when first step' do
        subject = Checkout::AccessService.new(order)
        allow(subject).to receive(:current_step).and_return(:address)
        expect(subject.step_dependencies).to be_blank
      end
    end

    describe '#allow?' do
      it 'when true' do
        expect(Corzinus::Checkout::AddressAccessService).to receive(:valid?)
          .with(order).and_return(true)
        expect(Corzinus::Checkout::PaymentAccessService).to receive(:valid?)
          .with(order).and_return(true)
        subject = Checkout::AccessService.new(order)
        allow(subject).to receive(:current_step).and_return(:delivery)
        allow(subject).to receive(:step_dependencies)
          .and_return([:address, :payment])
        subject.allow?
      end
    end
  end
end
