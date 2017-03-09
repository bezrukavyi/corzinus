include Corzinus::Support::CheckAttributes

module Corzinus
  feature 'User on cart', type: :feature do
    let(:person) { create :typical_user }
    let(:empty_order) { create :corzinus_order, person: person }
    let(:full_order) { create :corzinus_order, :with_products, person: person }
    let(:items) { full_order.order_items }
    let(:products) { items.map(&:productable) }

    scenario 'When person have order items' do
      allow_any_instance_of(Corzinus::CartsController)
        .to receive(:current_order).and_return(full_order)
      visit corzinus.edit_cart_path
      expect(page).to have_content I18n.t('corzinus.carts.title')
      expect(page).to have_no_content I18n.t('corzinus.carts.empty_message')
      check_title(products)
      check_price(products)
      check_price(items, :sub_total)
      check_title(items, :quantity)
      check_price(full_order, :sub_total)
      check_price(full_order, :sub_total)
    end

    scenario 'When person have empty cart' do
      allow_any_instance_of(CartsController).to receive(:current_order)
        .and_return(empty_order)
      visit corzinus.edit_cart_path
      expect(page).to have_content(I18n.t('corzinus.carts.empty_message'))
      expect(page).not_to have_content(I18n.t('corzinus.carts.update_cart'))
    end
  end
end
