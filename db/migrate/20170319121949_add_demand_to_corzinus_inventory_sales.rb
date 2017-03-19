class AddDemandToCorzinusInventorySales < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_inventory_sales, :demand, :integer
  end
end
