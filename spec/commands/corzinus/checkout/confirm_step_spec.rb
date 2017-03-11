module Corzinus
  describe Checkout::ConfirmStep do
    let(:order) { create :corzinus_order, :full_package, person: nil }
    let(:user) { create :typical_user }
    let(:params) { { confirm: true } }

    context 'valid' do
      subject do
        Checkout::ConfirmStep.new(order: order, person: user, params: params)
      end

      it 'set broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end

      it 'change order state' do
        expect { subject.call }.to change(order, :state).from('processing')
          .to('in_progress')
      end
    end

    context 'invalid' do
      subject do
        Checkout::ConfirmStep.new(order: order, person: user, params: nil)
      end
      it 'set broadcast' do
        expect { subject.call }.to broadcast(:invalid)
      end

      it 'change order state' do
        expect { subject.call }.not_to change(order, :state)
      end
    end
  end
end
