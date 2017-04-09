module Corzinus
  describe Checkout::AddressStep do
    let(:order) { create :corzinus_order }

    context 'valid' do
      let(:params) { { order: double('order'), use_base_address: true } }
      subject { Checkout::AddressStep.new(order: order, params: params) }
      %i(shipping billing).each do |type|
        let(:"#{type}_form") do
          AddressForm.from_params(attributes_for(:corzinus_address_order,
                                                 type.to_sym))
        end
      end

      before do
        expect_any_instance_of(Checkout::AddressStep)
          .to receive(:addresses_by_params)
          .with(params[:order], params[:use_base_address])
          .and_return([shipping_form, billing_form])
      end

      it 'create new addresses' do
        expect { subject.call }.to change { Address.count }.by(2)
      end
      it 'update order use_base_address' do
        expect { subject.call }.to change(order, :use_base_address)
      end
      it 'set broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'update order addresses' do
        %i(shipping billing).each do |type|
          expect { subject.call }.to change(order, type.to_sym)
        end
      end
    end

    context 'invalid' do
      let(:params) { { use_base_address: false } }
      subject { Checkout::AddressStep.new(order: order, params: params) }
      let(:invalid_form) do
        AddressForm.from_params(attributes_for(:corzinus_address_order,
                                               :invalid))
      end
      before do
        expect_any_instance_of(Checkout::AddressStep)
          .to receive(:addresses_by_params)
          .and_return([invalid_form])
      end
      it 'set broadcast' do
        expect { subject.call }.to broadcast(:invalid)
      end
      it 'dont update addresses' do
        %i(shipping billing).each do |type|
          expect { subject.call }.not_to change(order, type.to_sym)
        end
      end
      it 'dont update order use_base_address' do
        expect { subject.call }.not_to change(order, :use_base_address)
      end
      it 'dont create new address' do
        expect { subject.call }.not_to change { Address.count }
      end
    end
  end
end
