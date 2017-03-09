include Corzinus::Support::Order

module Corzinus
  feature 'User update order item', type: :feature do
    let(:person) { create :typical_user }
    let(:order) { create :corzinus_order, :with_products, person: person }
    let(:items) { order.order_items }

    before do
      allow_any_instance_of(Corzinus::CartsController)
        .to receive(:current_order).and_return(order)
      visit corzinus.edit_cart_path
    end

    context 'Success update quantity' do
      scenario 'desktop form' do
        fill_order('update_order', [3, 1])
        expect(page).to have_content(I18n.t('corzinus.flash.success.cart_update'))
      end
      scenario 'mobile form' do
        fill_order('update_order_mobile', 5)
        expect(page).to have_content(I18n.t('corzinus.flash.success.cart_update'))
      end
    end

    context 'Failure update quantity' do
      scenario 'desktop form' do
        fill_order('update_order', 1000)
        expect(page).to have_content(I18n.t('corzinus.flash.failure.cart_update'))
      end
      scenario 'mobile form' do
        fill_order('update_order_mobile', 1000)
        expect(page).to have_content(I18n.t('corzinus.flash.failure.cart_update'))
      end
    end

    scenario 'Destroy item', js: true do
      delete_link = "//a[@href='/corzinus/order_items/#{items.first.id}']"
      page.first(:xpath, delete_link).click
      expect(page).to have_content(I18n.t('corzinus.flash.success.product_destroy',
                                          title: items.first.productable.title))
    end
  end
end
