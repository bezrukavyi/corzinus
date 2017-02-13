module Corzinus
  RSpec.describe Country, type: :model do
    subject { build :corzinus_country }

    context 'association' do
      it { should have_many :deliveries }
    end

    context 'validation' do
      it { should validate_presence_of(:name) }
    end
  end
end
