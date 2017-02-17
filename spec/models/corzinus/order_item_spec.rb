module Corzinus
  RSpec.describe OrderItem, type: :model do
    subject { build :corzinus_order_item, :book_item }

    context 'association' do
      it { should belong_to :productable }
      it { expect(subject).to belong_to :order }
    end

    context 'validation' do
      it do
        should validate_numericality_of(:quantity)
          .is_greater_than_or_equal_to(0)
      end
      it do
        should validate_numericality_of(:quantity)
          .is_less_than_or_equal_to(99)
      end

      describe '#stock_validate' do
        it 'invalid' do
          subject.productable.count = 5
          subject.quantity = 6
          expect(subject).not_to be_valid
        end
        it 'valid' do
          subject.productable.count = 5
          subject.quantity = 4
          expect(subject).to be_valid
        end
      end
    end
  end
end
