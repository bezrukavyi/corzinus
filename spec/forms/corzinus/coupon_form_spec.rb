module Corzinus
  describe CouponForm, :coupon_form do
    let(:coupon) { create :corzinus_coupon }
    subject { CouponForm.from_model coupon }

    it 'valid object' do
      is_expected.to be_valid
    end

    it 'lower validate if code not exist' do
      subject.code = ''
      is_expected.to be_valid
    end

    it '#exist_coupon' do
      subject.code = 'Test'
      subject.valid?
      expect(subject.errors.full_messages).to include('Code ' +
        I18n.t('validators.coupon.not_found'))
    end

    it '#activated_coupon' do
      used_coupon = create :corzinus_coupon, :used
      coupon_form = CouponForm.from_model used_coupon
      coupon_form.valid?
      expect(coupon_form.errors.full_messages).to include('Code ' +
        I18n.t('validators.coupon.used'))
    end

    it '#valid? with order' do
      order = create :corzinus_order
      order.coupon = create :corzinus_coupon
      subject.valid?(order)
      expect(subject.errors.full_messages).to include('Code ' +
        I18n.t('validators.coupon.check_order'))
    end
  end
end
