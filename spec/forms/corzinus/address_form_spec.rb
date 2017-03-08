module Corzinus
  RSpec.describe AddressForm, type: :model do
    let(:addressable) { create :typical_user }

    subject do
      attributes = attributes_for(:corzinus_address, :shipping,
                                  addressable_id: addressable.id,
                                  addressable_type: 'TypicalUser')
      AddressForm.from_params(attributes)
    end

    context 'validation' do
      %i(first_name last_name name zip phone city).each do |attribute_name|
        it { should validate_presence_of(attribute_name) }
      end

      %i(country_id address_type).each do |attribute_name|
        it { should validate_presence_of(attribute_name) }
      end

      it { should validate_length_of(:zip).is_at_most(10) }

      %i(first_name last_name city).each do |attribute_name|
        it { should validate_length_of(attribute_name).is_at_most(50) }
      end

      context 'phone' do
        it { should validate_length_of(:phone).is_at_least(9) }
        it { should validate_length_of(:phone).is_at_most(15) }

        it 'format' do
          subject.phone = '+380AAAAA42342'
          is_expected.not_to be_valid
        end

        it '#wrong_code' do
          country = create :corzinus_country, code: '280'
          subject.country_id = country.id
          subject.phone = '+380632863823'
          is_expected.not_to be_valid
        end
      end

      it 'country' do
        subject.country_id = nil
        is_expected.not_to be_valid
      end
    end

    describe '#merge_info' do
      let(:object) { create :typical_user }
      it 'when form have attribute' do
        subject.first_name = nil
        subject.last_name = nil
        subject.merge_info(object)
        expect(subject.first_name).to eq(object.first_name)
        expect(subject.last_name).to eq(object.last_name)
      end
      it 'when form havent attribute' do
        expect { subject.merge_info(object) }.not_to change(subject, :first_name)
      end
    end
  end
end
