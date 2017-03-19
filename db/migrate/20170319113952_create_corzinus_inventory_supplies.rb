class CreateCorzinusInventorySupplies < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_inventory_supplies do |t|
      t.integer :size
      t.datetime :arrived_at
      t.references :inventory_sale, index: true

      t.timestamps
    end
  end
end
