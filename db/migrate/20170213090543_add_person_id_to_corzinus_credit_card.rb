class AddPersonIdToCorzinusCreditCard < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_credit_cards, :person_id, :integer, index: true
  end
end
