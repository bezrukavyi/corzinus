include Corzinus::Support::PersonsController
include Corzinus::Support::Order

module Corzinus
  feature 'Delivery step', type: :feature do
    let(:person) { create :typical_user }
    let(:order) { create :corzinus_order, :full_package, person: person }

    background do
      stub_current_order(order)
      stub_current_person(Corzinus::ApplicationController, person, :instance)
    end

    scenario "When person don't confirm" do
      visit corzinus.checkout_path(id: :complete)
      expect(current_path).to eq(corzinus.checkout_path(id: :confirm))
      expect(page).to have_content(I18n.t('corzinus.flash.failure.step'))
    end

    scenario 'When person confirm' do
      visit corzinus.checkout_path(id: :confirm)
      check_order_info(order)
      click_button I18n.t('corzinus.checkouts.confirm.place_order')
      expect(current_path).to eq corzinus.checkout_path(id: :complete)
    end
  end
end
