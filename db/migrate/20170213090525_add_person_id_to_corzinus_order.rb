class AddPersonIdToCorzinusOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_orders, :person_id, :integer, index: true
  end
end
