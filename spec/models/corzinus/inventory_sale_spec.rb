module Corzinus
  describe InventorySale, type: :model do
    subject { build :corzinus_inventory_sale }

    context 'association' do
      it { should belong_to :inventory }
    end

    context 'validations' do
      it do
        should validate_numericality_of(:start_stock)
          .is_greater_than_or_equal_to(0)
      end
      it { should validate_presence_of(:start_stock) }
    end
  end
end
