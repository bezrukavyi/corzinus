module Corzinus
  describe Inventory, type: :model do
    subject { build :corzinus_inventory }

    context 'association' do
      it { should belong_to :productable }
      it { should have_many :sales }
    end

    context 'validations' do
      it do
        should validate_numericality_of(:count)
          .is_greater_than_or_equal_to(0)
      end
    end
  end
end
