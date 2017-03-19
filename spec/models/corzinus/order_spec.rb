module Corzinus
  describe Order, type: :model do
    subject { create :corzinus_order }

    context 'associations' do
      %i(person credit_card delivery).each do |model_name|
        it { should belong_to(model_name) }
      end
      it { should have_many(:order_items) }
      it { should have_one(:coupon) }
      it { should accept_nested_attributes_for(:order_items) }
    end

    context 'aasm state' do
      it 'in_progress -> processing' do
        expect(subject).to transition_from(:in_progress).to(:processing)
          .on_event(:confirm)
      end
      it 'processing -> in_transit' do
        expect(subject).to transition_from(:processing).to(:in_transit)
          .on_event(:sent)
      end
      it 'in_transit -> delivered' do
        expect(subject).to transition_from(:in_transit).to(:delivered)
          .on_event(:delivered)
      end
      it 'in_progress -> cancel' do
        expect(subject).to transition_from(:processing).to(:canceled)
          .on_event(:cancel)
      end
    end

    describe 'aasm #confirm' do
      # it '#set_paid_at' do
      #   expect { subject.confirm }.to change { subject.paid_at }
      # end
      it '#decrease_stock!' do
        subject = create :corzinus_order, :with_products
        subject.order_items.each do |order_item|
          expect(order_item).to receive(:decrease_stock!)
        end
        subject.confirm
      end
    end

    context '#add_item!' do
      it 'when order item exist' do
        order_item = create :corzinus_order_item, order: subject
        expect { subject.add_item!(order_item.productable, 20).save }
          .to change { order_item.reload.quantity }.by(20)
      end
      it 'when order item not exist' do
        product = create :typical_product, :with_inventory
        expect { subject.add_item!(product) }
          .to change { OrderItem.count }.by(1)
      end
      it 'when order item quantity is zero' do
        product = create :typical_product, :with_inventory
        expect(subject.add_item!(product, 0)).to be_nil
      end
    end

    describe '#merge_order!' do
      it 'when current order' do
        order = create :corzinus_order, :with_products
        expect { order.merge_order!(order) }.not_to change(order, :order_items)
      end
      context 'when another order' do
        let(:product) { create :typical_product, :with_inventory }
        let(:coupon) { create :corzinus_coupon }
        let(:first_item) { create :corzinus_order_item, productable: product, quantity: 2 }
        let(:second_item) { create :corzinus_order_item, productable: product, quantity: 2 }
        let(:first_order) { create :corzinus_order, order_items: [first_item] }
        let(:second_order) do
          create :corzinus_order, order_items: [second_item], coupon: coupon
        end

        it 'update order_item quantity' do
          expect { first_order.merge_order!(second_order) }
            .to change { first_item.reload.quantity }.by(2)
        end
        it 'update order total_price' do
          expect { first_order.merge_order!(second_order) }
            .to change { first_order.reload.total_price }
        end
        context 'update coupon' do
          it 'when coupon exist' do
            first_order.merge_order!(second_order)
            expect(first_order.reload.coupon).not_to be_nil
          end
          it 'when coupon not exist' do
            second_order.coupon = nil
            first_order.merge_order!(second_order)
            expect(first_order.reload.coupon).to be_nil
          end
          it 'when first order have coupon' do
            first_order.coupon = create :corzinus_coupon
            expect { first_order.merge_order!(second_order) }
              .to change { first_order.reload.coupon }.to(coupon)
          end
        end
      end
      it 'return first_order' do
        first_order = create :corzinus_order, :with_products
        second_order = create :corzinus_order, :with_products
        expect(first_order.merge_order!(second_order)).to eq(first_order)
      end
    end

    it '#sub_total' do
      items = create_list :corzinus_order_item, 2, order: subject
      expect(subject.reload.sub_total).to eq(items.map(&:sub_total).sum)
    end

    it '#coupon_cost' do
      subject.coupon = build :corzinus_coupon, discount: 50
      allow(subject).to receive(:sub_total).and_return(100)
      expect(subject.coupon_cost).to eq(-50.0)
    end

    describe '#calc_total_cost' do
      it 'without coupon' do
        expect(subject.calc_total_cost).to eq(subject.sub_total)
      end
      it 'with coupon' do
        allow(subject).to receive(:sub_total).and_return(30)
        allow(subject).to receive(:coupon_cost).and_return(-20)
        expect(subject.calc_total_cost(:coupon)).to eq(10)
      end
      it 'with coupon and delivery' do
        allow(subject).to receive(:sub_total).and_return(10)
        allow(subject).to receive(:coupon_cost).and_return(-20)
        allow(subject).to receive(:delivery_cost).and_return(20)
        expect(subject.calc_total_cost(:coupon, :delivery)).to eq(10)
      end
    end

    it '#access_deliveries' do
      country = create :corzinus_country
      shipping = create :corzinus_address_order, :shipping, country: country
      first_delivery = create :corzinus_delivery, country: country
      second_delivery = create :corzinus_delivery, country: country
      allow(subject).to receive(:shipping).and_return(shipping)
      expect(subject.access_deliveries).to be_include(first_delivery)
      expect(subject.access_deliveries).to be_include(second_delivery)
    end

    describe '#any_address?' do
      it 'when true' do
        create :corzinus_address_order, :shipping, addressable: subject
        expect(subject.any_address?).to be_truthy
      end
      it 'when false' do
        subject.shipping = nil
        expect(subject.any_address?).to be_falsey
      end
    end

    context 'Before save' do
      it '#update_total_price' do
        subject.order_items = [create(:corzinus_order_item)]
        expect { subject.save }.to change { subject.total_price }
      end
    end

    it '.not_empty' do
      create :corzinus_order, :with_products
      empty_order = create :corzinus_order, order_items: []
      expect(Order.not_empty).not_to include(empty_order)
    end
  end
end
