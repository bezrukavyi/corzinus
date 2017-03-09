include Corzinus::Support::PersonsController

module Corzinus
  describe ApplicationController, type: :controller do
    describe '#current_order' do
      before do
        stub_current_person(controller, nil)
      end

      it 'order with session' do
        order = create :corzinus_order
        session[:order_id] = order.id
        expect(controller.current_order).to eq(order)
      end

      context 'order without session' do
        it 'create order' do
          expect { controller.current_order }.to change { Order.count }.by(1)
        end
        it 'set session' do
          expect { controller.current_order }.to change { session[:order_id] }
        end
      end

      context 'order with current_user' do
        let(:order) { create :corzinus_order, :with_products }
        let(:person) { create :typical_user }

        before do
          allow(Order).to receive(:find_by).and_return(order)
          stub_current_person(controller, person)
        end

        it 'merge order' do
          person_order = create :corzinus_order
          expect(person).to receive(:order_in_processing)
            .and_return(person_order)
          expect(person_order).to receive(:merge_order!).with(order)
            .and_return(order)
          controller.current_order
        end
      end
    end
  end
end
