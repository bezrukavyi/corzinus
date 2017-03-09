include Corzinus::Support::PersonsController

module Corzinus
  describe OrderItemsController, type: :controller do
    routes { Corzinus::Engine.routes }

    let(:person) { create :typical_user }
    let(:order) { create :corzinus_order, :with_products }
    subject { order.order_items.first }

    before do
      stub_current_person(controller, person)
      allow(controller).to receive(:current_order).and_return(order)
    end

    describe 'POST #create' do
      let(:productable_id) { subject.productable_id }
      let(:productable_type) { subject.productable_type }
      let(:params) do
        {
          productable_id: productable_id,
          productable_type: productable_type,
          quantity: 20
        }
      end

      it 'UpdateUser call' do
        allow(controller).to receive(:params).and_return(params)
        expect(AddOrderItem).to receive(:call).with(order, params)
        put :create
      end

      context 'success update' do
        before do
          stub_const('Corzinus::AddOrderItem', Support::Command::Valid)
          Support::Command::Valid.block_value = 20
          put :create
        end
        it 'notice flash' do
          expect(flash[:notice])
            .to eq I18n.t('corzinus.flash.success.product_add', count: 20)
        end
        it 'redirect_back' do
          expect(response).to redirect_to(root_path)
        end
      end

      context 'failure update' do
        before do
          stub_const('Corzinus::AddOrderItem', Support::Command::Invalid)
          Support::Command::Invalid.block_value = 'errors'
          put :create
        end
        it 'alert flash' do
          message = I18n.t('corzinus.flash.failure.product_add',
                           errors: 'errors')
          expect(flash[:alert]).to eq message
        end
        it 'redirect_back' do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe 'DELETE #destroy' do
      before do
        allow(OrderItem).to receive(:find).and_return(subject)
      end
      context 'success destroy' do
        before do
          allow(subject).to receive(:destroy).and_return(true)
          allow(order).to receive(:save).and_return(true)
          delete :destroy, params: { id: subject.id }
        end

        it 'notice flash' do
          message = I18n.t('corzinus.flash.success.product_destroy',
                           title: subject.productable.title)
          expect(flash[:notice]).to eq message
        end

        it 'renders the :show template' do
          expect(response).to redirect_to(edit_cart_path)
        end
      end

      context 'failed destroy' do
        before do
          allow(subject).to receive(:destroy).and_return(false)
          allow(subject).to receive_message_chain(:decorate, :all_errors)
            .and_return('errors')
          allow(order).to receive(:save).and_return(false)
          delete :destroy, params: { id: subject.id }
        end

        it 'alert falsh' do
          message = I18n.t('corzinus.flash.failure.product_destroy',
                           errors: 'errors')
          expect(flash[:alert]).to eq message
        end

        it 'redirect_to edit_cart_path' do
          expect(response).to redirect_to(edit_cart_path)
        end
      end
    end
  end
end
