include Corzinus::Support::CheckAttributes
include Corzinus::Support::Inventory

module Corzinus
  feature 'User on inventory page', type: :feature do
    let(:inventory) { create :corzinus_inventory }

    scenario 'User can show date of sales' do
      sales = generate_sales_with_demands(inventory)
      visit corzinus.inventory_path(inventory)
      check_title(sales, :start_stock)
      check_title(sales, :demand)
      check_title(sales, :finish_stock)
    end
  end
end
