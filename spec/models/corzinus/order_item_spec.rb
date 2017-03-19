module Corzinus
  describe OrderItem, type: :model do
    subject { build :corzinus_order_item }

    context 'association' do
      it { should belong_to :productable }
      it { expect(subject).to belong_to :order }
    end

    context 'validation' do
      it do
        should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0)
      end
      it do
        should validate_numericality_of(:quantity).is_less_than_or_equal_to(99)
      end
    end

    it '#sub_total' do
      subject.productable = create :typical_product, price: 10
      subject.quantity = 2
      expect(subject.sub_total).to eq(20)
    end

    it '#decrease_stock!' do
      quantity_change = subject.quantity * -1
      expect { subject.decrease_stock! }
        .to change { subject.productable.inventory.reload.count }
        .by(quantity_change)
    end

    context 'Before validation' do
      it '#destroy_if_empty' do
        item = create :corzinus_order_item
        item.quantity = 0
        expect { item.valid? }.to change { OrderItem.count }.by(-1)
      end
    end
  end
end
