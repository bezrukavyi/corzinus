class AddUseBaseAddressToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_orders, :use_base_address, :boolean
  end
end
