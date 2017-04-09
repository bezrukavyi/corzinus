module Corzinus
  RSpec.describe CreditCard, type: :model do
    subject { build :corzinus_credit_card }

    context 'association' do
      it { should have_many :orders }
      it { should belong_to :person }
    end
  end
end
