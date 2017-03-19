class AddPaidAtToCorzinusOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_orders, :paid_at, :datetime
  end
end
