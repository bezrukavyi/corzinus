module Corzinus
  RSpec.describe OrderItem, type: :model do
    subject { build :corzinus_order_item }

    context 'association' do
      it { should belong_to :productable }
      it { expect(subject).to belong_to :order }
    end
  end
end
