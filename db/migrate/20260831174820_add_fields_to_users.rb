class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false
    add_reference :users, :role, null: false, foreign_key: true
    add_column :users, :billing_day, :integer
  end
end
