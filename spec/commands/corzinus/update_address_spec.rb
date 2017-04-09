module Corzinus
  describe UpdateAddress do
    let(:addressable) { create :corzinus_order }

    context 'valid' do
      let(:params) { { address: attributes_for(:corzinus_address, :shipping) } }
      subject do
        UpdateAddress.new(addressable: addressable, params: params)
      end

      let(:shipping_form) do
        AddressForm.from_params(params[:address])
      end

      before do
        expect_any_instance_of(UpdateAddress)
          .to receive(:address_by_params).with(params[:address])
          .and_return(shipping_form)
      end

      it 'create new addresses' do
        expect { subject.call }.to change { Address.count }.by(1)
      end
      it 'set broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'update order shipping' do
        expect { subject.call }.to change(addressable, :shipping)
      end
    end
  end
end
