module Corzinus
  describe CheckoutMailer, type: :mailer do
    describe '#complete' do
      let(:user) { create :typical_user }
      let(:order) { create :corzinus_order, person: user }
      let(:order_item) { create :corzinus_order_item, order: order }
      let(:mail) { described_class.complete(user, order).deliver_now }

      it 'renders the subject' do
        expect(mail.subject).to eq("Complete Order ##{order.id}")
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'assigns @order' do
        expect(mail.body.encoded).to match("Order ##{order.id}")
      end

      it 'send mail' do
        expect { mail }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
