class CreateCorzinusOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_order_items do |t|
      t.integer :quantity
      t.references :order, index: true

      t.timestamps
    end
  end
end
