module Corzinus
  RSpec.describe Delivery, type: :model do
    subject { build :corzinus_delivery }

    context 'association' do
      it { should have_many :orders }
      it { should belong_to :country }
    end
  end
end
