module Corzinus
  describe InventorySale, type: :model do
    subject { build :corzinus_inventory_sale }

    context 'association' do
      it { should belong_to :inventory }
      it { should have_one :supply }
    end

    context 'validations' do
      it do
        should validate_numericality_of(:start_stock)
          .is_greater_than_or_equal_to(0)
      end
      it { should validate_presence_of(:start_stock) }
    end

    describe '#finish!' do
      it 'update finish_stock' do
        expect { subject.finish!(10) }.to change { subject.finish_stock }.to(10)
      end
      it 'update demand' do
        subject.start_stock = 100
        expect { subject.finish!(10) }.to change { subject.demand }.to(90)
      end
    end

    describe '#issue_supply' do
      it 'when create supply' do
        allow(subject.inventory).to receive(:need_supply?).and_return(true)
        allow(subject.inventory).to receive(:average_demand).and_return(5)
        expect(subject.supply).to be_blank
        subject.save
        expect(subject.supply.size).to eq(5 * InventorySupply::TIME_RESERVE)
      end
      it 'when dont create supply' do
        allow(subject.inventory).to receive(:need_supply?).and_return(false)
        subject.save
        expect(subject.supply).to be_blank
      end
    end
  end
end
