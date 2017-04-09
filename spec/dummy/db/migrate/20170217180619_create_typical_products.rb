class CreateTypicalProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :typical_products do |t|
      t.string :title
      t.decimal :price, precision: 10, scale: 2
      t.integer :count

      t.timestamps
    end
  end
end
