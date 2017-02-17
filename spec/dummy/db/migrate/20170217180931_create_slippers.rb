class CreateSlippers < ActiveRecord::Migration[5.0]
  def change
    create_table :slippers do |t|
      t.string :title
      t.decimal :price, precision: 10, scale: 2
      t.integer :count

      t.timestamps
    end
  end
end
