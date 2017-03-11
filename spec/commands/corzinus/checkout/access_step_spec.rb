module Corzinus
  describe Checkout::AccessStep do
    let(:user) { create :typical_user }

    describe '#call' do
      it 'when allow' do
        order = create :corzinus_order, :with_products
        subject = Checkout::AccessStep.new(order, :address)
        allow(Corzinus::Checkout::AddressAccessService).to receive(:allow?)
          .with(order)
          .and_return(true)
        expect { subject.call }.to broadcast(:allow)
      end

      it 'when not_allow' do
        order = create :corzinus_order, :with_products
        subject = Checkout::AccessStep.new(order, :address)
        allow(Corzinus::Checkout::AddressAccessService).to receive(:allow?)
          .with(order)
          .and_return(false)
        expect { subject.call }.to broadcast(:not_allow)
      end

      it 'when empty_cart' do
        order = create :corzinus_order, person: user
        subject = Checkout::AccessStep.new(order, :delivery)
        expect { subject.call }.to broadcast(:empty_cart)
      end
    end
  end
end
