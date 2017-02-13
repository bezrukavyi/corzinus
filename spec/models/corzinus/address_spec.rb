module Corzinus
  RSpec.describe Address, type: :model do
    subject { build :corzinus_address, :billing }

    context 'associations' do
      it { should belong_to :addressable }
      it { should belong_to :country }
    end

    context 'enum address type' do
      it 'billing' do
        address = build :corzinus_address, :billing
        expect(address.address_type).to eq('billing')
      end
      it 'shipping' do
        address = build :corzinus_address, :shipping
        expect(address.address_type).to eq('shipping')
      end
    end
  end
end
