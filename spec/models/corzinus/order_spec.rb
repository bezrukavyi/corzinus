module Corzinus
  RSpec.describe Order, type: :model do
    subject { build :corzinus_order }

    context 'associations' do
      [:credit_card, :delivery, :person].each do |model_name|
        it { should belong_to model_name }
      end
      it { should have_many :order_items }
      it { should have_one :coupon }

      [:order_items, :credit_card].each do |model_name|
        it { should accept_nested_attributes_for model_name }
      end
    end
  end
end
