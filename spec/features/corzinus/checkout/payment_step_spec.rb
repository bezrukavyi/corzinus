include Corzinus::Support::PersonsController
include Corzinus::Support::Order

module Corzinus
  feature 'Payment step', type: :feature do
    let(:person) { create :typical_user }
    let(:order) { create :corzinus_order, :full_package, person: person }

    background do
      stub_current_order(order)
      stub_current_person(Corzinus::ApplicationController, person, :instance)
    end

    scenario "When user don't choose delivery" do
      order.delivery = nil
      visit corzinus.checkout_path(id: :payment)
      expect(current_path).to eq(corzinus.checkout_path(id: :delivery))
      expect(page).to have_content(I18n.t('corzinus.flash.failure.step'))
    end

    scenario "When user don't fill credit_card" do
      order.update_attribute(:credit_card, nil)
      visit corzinus.checkout_path(id: :payment)
      click_button I18n.t('simple_form.titles.save_and_continue')
      expect(page).to have_content(I18n.t('errors.messages.blank'))
    end

    scenario 'When user fill all fields' do
      order.update_attribute(:credit_card, nil)
      visit corzinus.checkout_path(id: :payment)
      fill_credit_card('credit_card_form', attributes_for(:corzinus_credit_card), false)
      click_button I18n.t('simple_form.titles.save_and_continue')
      expect(current_path).to eq(corzinus.checkout_path(id: :confirm))
    end
  end
end
