class AddUniqueIndexesToUsers < ActiveRecord::Migration[8.1]
  def change
    add_index :users, :email, unique: true
    add_index :users, :auth_token, unique: true
  end
end
