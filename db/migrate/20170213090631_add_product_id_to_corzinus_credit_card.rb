class AddProductIdToCorzinusCreditCard < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_credit_cards, :product_id, :integer, index: true
  end
end
