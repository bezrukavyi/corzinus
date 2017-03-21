include Corzinus::Support::CheckAttributes

module Corzinus
  feature 'User on inventory page', type: :feature do
    background do
      create_list :corzinus_inventory, 4
      visit corzinus.inventories_path
    end

    scenario 'User can see inventories details' do
      inventories = Inventory.all
      productables = inventories.map(&:productable)
      check_title(inventories.decorate, :created_strftime)
      check_title(inventories, :count)
      check_title(inventories.decorate, :nearest_supply_relative)
      check_title(productables)
      check_show_link(inventories, I18n.t('corzinus.more'))
    end
  end
end
