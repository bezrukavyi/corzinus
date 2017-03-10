include Corzinus::Support::PersonsController

module Corzinus
  feature 'Delivery step', type: :feature do
    let(:person) { create :typical_user }
    let(:order) { create :corzinus_order, :full_package, person: person }

    background do
      @delivery = create :corzinus_delivery, country: order.shipping.country
      allow_any_instance_of(Corzinus::CheckoutsController)
        .to receive(:current_order).and_return(order)
      stub_current_person(Corzinus::ApplicationController, person, :instance)
    end

    scenario "When person don't choose address" do
      order.shipping = nil
      visit corzinus.checkout_path(id: :delivery)
      expect(current_path).to eq(corzinus.checkout_path(id: :address))
      expect(page).to have_content(I18n.t('corzinus.flash.failure.step'))
    end

    scenario "When person don't fill delivery" do
      order.update_attribute(:delivery, nil)
      visit corzinus.checkout_path(id: :delivery)
      click_button I18n.t('simple_form.titles.save_and_continue')
      expect(current_path).to eq(corzinus.checkout_path(id: :delivery))
    end

    scenario 'When person choose delivery and continue checkout' do
      order.update_attribute(:delivery, nil)
      visit corzinus.checkout_path(id: :delivery)
      first('label', text: @delivery.name).click
      click_button I18n.t('simple_form.titles.save_and_continue')
      expect(current_path).to eq(corzinus.checkout_path(id: :payment))
    end
  end
end
