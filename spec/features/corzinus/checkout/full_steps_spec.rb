include Corzinus::Support::PersonsController
include Corzinus::Support::Order

module Corzinus
  feature 'Full steps', type: :feature do
    let(:order) { create :corzinus_order, :with_products }
    let(:person) { create :typical_user, orders: [order] }
    let(:billing_attrs) { attributes_for :corzinus_address_person, :billing }
    let(:shipping_attrs) { attributes_for :corzinus_address_person, :shipping }
    let(:card_attr) { attributes_for :corzinus_credit_card }

    background do
      @delivery = create :corzinus_delivery
      stub_current_order(order)
      stub_current_person(Corzinus::ApplicationController, person, :instance)
    end

    scenario 'User run all steps', js: true do
      visit corzinus.checkout_path(id: :address)
      fill_address('billing_address', billing_attrs, false)
      fill_address('shipping_address', shipping_attrs, false)
      click_button I18n.t('simple_form.titles.save_and_continue')

      first('label', text: @delivery.name).click
      click_button I18n.t('simple_form.titles.save_and_continue')

      fill_credit_card('credit_card_form', attributes_for(:corzinus_credit_card), false)
      click_button I18n.t('simple_form.titles.save_and_continue')

      check_order_info(order)
      click_button I18n.t('corzinus.checkouts.confirm.place_order')

      expect(page).to have_content(I18n.t('corzinus.checkouts.complete.thanks_message'))
      expect(page).to have_content(I18n.t('corzinus.checkouts.complete.email_confirm',
                                          email: person.email))
      expect(page).to have_content(I18n.t('corzinus.checkouts.complete.order_id',
                                          id: order.id))
    end
  end
end
