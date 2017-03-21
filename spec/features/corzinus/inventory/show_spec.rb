include Corzinus::Support::CheckAttributes
include Corzinus::Support::Inventory

module Corzinus
  feature 'User on inventory page', type: :feature do
    let(:inventory) { create :corzinus_inventory, :with_supplies }

    background do
      visit corzinus.inventory_path(inventory)
    end

    # scenario 'User can see inventory details' do
    #   check_title(inventory, :id)
    #   check_title(inventory.productable, :title)
    # end

    scenario 'User can see supplies details' do
      supplies = inventory.supplies
      check_title(supplies.decorate, :created_strftime)
      check_title(supplies.decorate, :arrived_strftime)
      check_title(supplies, :size)
    end
  end
end
