module Corzinus
  describe Inventory, type: :model do
    subject { build :corzinus_inventory }

    context 'association' do
      it { should belong_to :productable }
      it { should have_many :sales }
      it { should have_many :supplies }
    end

    context 'validations' do
      it do
        should validate_numericality_of(:count)
          .is_greater_than_or_equal_to(0)
      end
    end

    describe '#add_sale' do
      before do
        subject.save
      end
      it 'update finish stock to last sale' do
        subject.sales.create(start_stock: 100, created_at: DateTime.now - 2.days)
        last_sale = subject.sales.create(start_stock: 200, created_at: DateTime.now - 1.days)
        expect { subject.add_sale }
          .to change { last_sale.reload.finish_stock }
          .from(nil).to(subject.count)
      end
      it 'update count by supply' do
        sale = create :corzinus_inventory_sale, inventory: subject
        sale.supply = create :corzinus_inventory_supply, sale: sale
        allow(subject).to receive(:arrived_supply).and_return(sale.supply)
        allow(sale.supply).to receive(:size).and_return(10)
        subject.count = 100
        expect { subject.add_sale }.to change { subject.count }.from(100).to(110)
      end
      it 'create new sale stock' do
        expect { subject.add_sale }.to change { subject.sales.count }.by(1)
      end
    end

    describe '#need_supply?' do
      before do
        subject.save
        [10, 10, 5, 5, 5, 5, 5, 5, 5].each_with_index do |demand, index|
          date = DateTime.now - index.days
          subject.sales.create(start_stock: 10, demand: demand, created_at: date)
        end
      end
      it 'when true' do
        subject.count = 25
        expect(subject.need_supply?).to be_truthy
      end
      it 'when falsey' do
        subject.count = 100
        expect(subject.need_supply?).to be_falsey
      end
    end

    it '#arrived_supply' do
      time = Time.zone.now
      delivery = InventorySupply::DELIVERY_DAYS
      delivery.downto(0) do |index_day|
        date = time - index_day.days
        sale = create :corzinus_inventory_sale, inventory: subject, created_at: date
        create :corzinus_inventory_supply, created_at: date, size: 10, sale: sale
      end
      arrived_supply = subject.supplies.where(created_at: time - delivery.days).first
      expect(subject.arrived_supply).to eq(arrived_supply)
    end

    it '#demands' do
      inventory = create :corzinus_inventory
      10.times do |index|
        finish_stock = index + 1
        inventory.sales.create(start_stock: 100, finish_stock: finish_stock)
      end
      expect(inventory.demands).to eq([90, 91, 92, 93, 94, 95])
    end
  end
end
