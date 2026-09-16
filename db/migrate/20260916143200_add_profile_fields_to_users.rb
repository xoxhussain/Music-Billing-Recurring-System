class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :about, :text
    add_column :users, :interests, :text
  end
end
