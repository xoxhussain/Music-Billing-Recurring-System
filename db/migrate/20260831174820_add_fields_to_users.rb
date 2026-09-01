class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :role, :string, null: false, default: "buyer"
    add_column :users, :billing_day, :integer
  end
end
