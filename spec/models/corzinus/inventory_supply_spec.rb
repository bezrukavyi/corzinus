module Corzinus
  describe InventorySupply, type: :model do
    subject { build :corzinus_inventory_supply }

    context 'association' do
      it { should belong_to :sale }
    end
  end
end
