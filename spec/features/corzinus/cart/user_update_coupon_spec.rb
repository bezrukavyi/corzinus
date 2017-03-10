include Corzinus::Support::Order

module Corzinus
  feature 'User update coupon', type: :feature do
    let(:person) { create :typical_user }
    let(:order) { create :corzinus_order, :with_products, person: person }
    let(:coupon) { create :corzinus_coupon }

    before do
      stub_current_order(order)
      visit corzinus.edit_cart_path
    end

    scenario 'User fill with valid code' do
      fill_coupon('update_order', coupon.code)
      expect(page).to have_content(I18n.t('corzinus.flash.success.cart_update'))
      coupon_title = "#{I18n.t('corzinus.carts.coupon')} (#{coupon.discount}%):"
      expect(page).to have_no_content(coupon.code)
      expect(page).to have_content(coupon_title)
    end

    scenario 'User fill with invalid code' do
      code = 'Code10101'
      fill_coupon('update_order', code)
      expect(page).to have_content(I18n.t('corzinus.flash.failure.cart_update'))
      expect(first('#order_coupon_code').value).to eq(code)
      not_found = I18n.t('corzinus.validators.coupon.not_found')
      expect(page).to have_content(not_found)
    end
  end
end
