module Corzinus
  describe CartsController, type: :controller do
    routes { Corzinus::Engine.routes }

    subject { create :corzinus_order, :with_products }
    let(:order_item) { subject.order_items.first }
    let(:coupon) { create :corzinus_coupon }

    before do
      allow(controller).to receive(:current_order).and_return(subject)
    end

    describe 'GET #edit' do
      it 'assign coupon_form' do
        allow(CouponForm).to receive(:from_model).with(subject.coupon)
        get :edit
      end
    end

    describe 'PUT #update' do
      let(:params) { { order: { coupon: { code: coupon.code } } } }

      it 'UpdateOrder call' do
        allow(controller).to receive(:params).and_return(params)
        expect(UpdateOrder).to receive(:call).with(subject, params)
        put :update, params: params
      end

      context 'success update' do
        before do
          stub_const('Corzinus::UpdateOrder', Support::Command::Valid)
          put :update, params: params
        end
        it 'flash notice' do
          expect(flash[:notice])
            .to eq(I18n.t('corzinus.flash.success.cart_update'))
        end
        it 'redirect to edit user' do
          # expect(response).to redirect_to(edit_cart_path)
        end
      end

      context 'success update and to checkout' do
        before do
          stub_const('Corzinus::UpdateOrder', Support::Command::ToCheckout)
          put :update, params: params
        end
        it 'flash notice' do
          expect(flash[:notice])
            .to eq(I18n.t('corzinus.flash.success.cart_update'))
        end
        it 'redirect to edit user' do
          # expect(response).to redirect_to(checkout_path(:address))
        end
      end

      context 'failure update' do
        let(:coupon_form) { double('coupon_form') }
        before do
          stub_const('Corzinus::UpdateOrder', Support::Command::Invalid)
          Support::Command::Invalid.block_value = coupon_form
          put :update, params: params
        end
        it 'flash notice' do
          expect(flash[:alert])
            .to eq(I18n.t('corzinus.flash.failure.cart_update'))
        end
        it 'redirect to edit user' do
          expect(response).to render_template(:edit)
        end
        it 'instance coupon_form' do
          expect(assigns(:coupon_form)).to eq(coupon_form)
        end
      end
    end
  end
end
