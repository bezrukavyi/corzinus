class AddProductableToOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_reference :corzinus_order_items, :productable, polymorphic: true,
                   index: { name: 'index_corzinus_productable' }
  end
end
