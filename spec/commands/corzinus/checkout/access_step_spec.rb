module Corzinus
  describe Checkout::AccessStep do
    let(:user) { create :typical_user }

    describe '#call' do
      context 'When allow' do
        it ':address step' do
          order = create :corzinus_order, :with_products
          subject = Checkout::AccessStep.new(order, :address)
          expect { subject.call }.to broadcast(:allow)
        end

        it ':delivery step' do
          order = create :corzinus_order, :with_products, :with_addresses
          subject = Checkout::AccessStep.new(order, :delivery)
          expect { subject.call }.to broadcast(:allow)
        end

        it ':payment step' do
          order = create :corzinus_order, :with_products, :with_addresses,
                         :with_delivery
          subject = Checkout::AccessStep.new(order, :payment)
          expect { subject.call }.to broadcast(:allow)
        end

        it ':confirm step' do
          order = create :corzinus_order, :full_package
          subject = Checkout::AccessStep.new(order, :confirm)
          expect { subject.call }.to broadcast(:allow)
        end

        it ':complete step' do
          order = create :corzinus_order, :full_package
          order.confirm
          subject = Checkout::AccessStep.new(order, :complete)
          expect { subject.call }.to broadcast(:allow)
        end
      end

      context 'When empty_cart' do
        let(:order) { create :corzinus_order, person: user }

        it ':delivery step' do
          subject = Checkout::AccessStep.new(order, :delivery)
          expect { subject.call }.to broadcast(:empty_cart)
        end

        it ':payment step' do
          subject = Checkout::AccessStep.new(order, :payment)
          expect { subject.call }.to broadcast(:empty_cart)
        end

        it ':confirm step' do
          subject = Checkout::AccessStep.new(order, :confirm)
          expect { subject.call }.to broadcast(:empty_cart)
        end

        it ':complete step' do
          subject = Checkout::AccessStep.new(order, :complete)
          expect { subject.call }.to broadcast(:allow)
        end
      end
    end
  end
end
