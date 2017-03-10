include Corzinus::Support::Address
include Corzinus::Support::PersonsController

module Corzinus
  feature 'Address step', type: :feature do
    let(:person) { create :typical_user, :with_billing }
    let(:order) { create :corzinus_order, :with_products, person: person }
    let(:shipping_attrs) { attributes_for :corzinus_address_person, :shipping }

    background do
      allow_any_instance_of(CheckoutsController)
        .to receive(:current_order).and_return(order)
      stub_current_person(Corzinus::ApplicationController, person, :instance)
      visit corzinus.checkout_path(id: :address)
    end

    scenario 'When user not fill shipping address' do
      click_button I18n.t('simple_form.titles.save_and_continue')
      expect(page).to have_content(I18n.t('errors.messages.blank'))
    end

    scenario 'When user have billing address' do
      check_address_fields(person.billing)
      fill_address('shipping_address', shipping_attrs, false)
      click_button I18n.t('simple_form.titles.save_and_continue')
      expect(current_path).to eq corzinus.checkout_path(id: :delivery)
    end

    scenario 'When user want use billing address as base' do
      text = I18n.t('corzinus.checkouts.address.use_base_address')
      first('label', text: text).click
      click_button I18n.t('simple_form.titles.save_and_continue')
      expect(current_path).to eq corzinus.checkout_path(id: :delivery)
      visit corzinus.checkout_path(id: :address)
      expect(find('#use_base_address', visible: false)).to be_checked
    end
  end
end
