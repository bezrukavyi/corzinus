module Corzinus
  RSpec.describe OrderItem, type: :model do
    subject { build :corzinus_order_item }

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
        with_model :MockProduct do
          table do |t|
            t.string :title
            t.decimal :price
            t.integer :count
          end
        end

        before do
          subject.productable = MockProduct.create(title: 'Rspec', price: 100.0,
                                                   count: 100)
        end
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
