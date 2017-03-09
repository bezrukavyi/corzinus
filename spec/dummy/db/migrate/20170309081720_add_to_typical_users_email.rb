class AddToTypicalUsersEmail < ActiveRecord::Migration[5.0]
  def change
    add_column :typical_users, :email, :string
  end
end
